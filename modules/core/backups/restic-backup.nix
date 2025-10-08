# A backups module. Requires a share being mounted at `/mnt/backups`. Creates a repository `restic` owned by "jamie".
# TODO: Include mounting NFS share in this module somehow.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  resticEnvEtcFile = "restic/local.env";

  cfg = config.services.resticBackup;

  mkBackupService =
    name: backupCfg:
    nameValuePair "restic-backup-${name}" {
      description = "Restic backup service for ${name}";
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "restic-init.service"
      ];
      requires = [ "restic-init.service" ];
      serviceConfig = {
        ExecStart =
          let
            backupCmd = concatStringsSep " " (
              [
                "${pkgs.restic}/bin/restic"
                "backup"
                "--verbose"
              ]
              ++ backupCfg.paths
              ++ optionals (backupCfg.extraArgs != [ ]) backupCfg.extraArgs
            );
          in
          ''
            ${pkgs.bash}/bin/bash -c "source /etc/${resticEnvEtcFile} && ${backupCmd}"
          '';
        User = backupCfg.user;
        Group = backupCfg.group;
      };
    };

  mkBackupTimer = name: backupCfg: {
    "restic-backup-${name}" = {
      description = "Timer to run Restic backup for ${name}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = backupCfg.schedule;
        Persistent = true;
        RandomizedDelaySec = backupCfg.randomizedDelaySec;
      };
    };
  };
in
{
  options.services.resticBackup = {
    enable = mkEnableOption "Restic backup service";

    repositoryPath = mkOption {
      type = types.str;
      description = "Restic repository path";
      example = "/mnt/backups";
    };

    backups = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkEnableOption "Enable backup";

            paths = mkOption {
              type = types.listOf types.str;
              description = "List of paths to backup";
              example = [
                "/home"
                "/etc"
              ];
            };

            schedule = mkOption {
              type = types.str;
              default = "hourly";
              description = "When to run the backup (systemd calendar format)";
              example = "hourly";
            };

            user = mkOption {
              type = types.str;
              default = "jamie";
              description = "User to run the backup as";
            };

            group = mkOption {
              type = types.str;
              default = "root";
              description = "Group to run the backup as";
            };

            extraArgs = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "Extra arguments to pass to restic backup";
              example = [
                "--exclude=*.tmp"
                "--one-file-system"
              ];
            };

            randomizedDelaySec = mkOption {
              type = types.str;
              default = "600"; # Up to 10 minutes
              description = "Random delay before starting backup";
              example = "3600"; # Up to 1 hour random delay
            };
          };
        }
      );
      default = { };
      description = "Restic backup configurations";
    };
  };

  config = mkIf cfg.enable {
    environment.etc."${resticEnvEtcFile}".text = ''
      export RESTIC_REPOSITORY="/mnt/backups/restic"
      export RESTIC_PASSWORD_FILE="/run/agenix/restic-password"
    '';

    environment.systemPackages = with pkgs; [
      restic

      # Shortcut for accessing backups repo
      (writeShellScriptBin "backup" ''
        source /etc/${resticEnvEtcFile}
        exec ${restic}/bin/restic "$@"
      '')
    ];

    systemd.services = mkMerge [
      (builtins.listToAttrs (mapAttrsToList mkBackupService cfg.backups))
      {
        restic-init = {
          description = "Initialize Restic repository";
          wantedBy = [ "multi-user.target" ];
          after = [ "mnt-backups.mount" ];
          requires = [ "mnt-backups.mount" ];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "restic-init.sh" ''
              set -euo pipefail

              source /etc/${resticEnvEtcFile}

              if [ ! -d "$RESTIC_REPOSITORY" ]; then
                echo "Creating directory $RESTIC_REPOSITORY"
                mkdir -p "$RESTIC_REPOSITORY"
              fi

              # Check if repository needs to be initialized
              if ! ${pkgs.restic}/bin/restic cat config 2>/dev/null; then
                # Ensure directory is empty before initializing
                if [ -n "$(ls -A "$RESTIC_REPOSITORY")" ]; then
                  echo "Error: Directory $RESTIC_REPOSITORY is not empty"
                  exit 1
                fi

                chown jamie:root "$RESTIC_REPOSITORY"
                chmod 700 "$RESTIC_REPOSITORY"

                echo "Restic repository doesn't exist. Initializing..."
                ${pkgs.sudo}/bin/sudo -E -u jamie ${pkgs.restic}/bin/restic init
                echo "Restic repository initialized successfully"
              else
                echo "Restic repository already initialized"
              fi
            '';
            RemainAfterExit = true;
          };
        };
      }
    ];

    systemd.timers = mkMerge (mapAttrsToList mkBackupTimer cfg.backups);
  };
}
