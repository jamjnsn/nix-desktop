#
# W.I.P. Uses services.resticBackup to backup user's home directory.
#
# Usage:
#   users.users.jamie.backups.enable = true;
#
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  defaultExcludes = [
    "/.config/containers"
    "*/.local/share/containers/storage/overlay"

    # Cache directories
    "*/.cache"
    "*/.local/share/Trash"
    "*/.thumbnails"
    "*/.ccache"

    # Browser caches
    "*/.mozilla/firefox/*/Cache"
    "*/.config/google-chrome/*/Cache"
    "*/.config/chromium/*/Cache"

    # Development
    "*/.git"
    "*/node_modules"
    "*/.npm"
    "*/.yarn"
    "*/target" # Rust builds
    "*/build"
    "*/dist"
    "*/.gradle"
    "*/.m2/repository"

    # Temporary files
    "*/tmp"
    "*/.tmp"
    "*.tmp"
    "*.temp"
    "*~"
    "*.swp"
    "*.swo"

    # Log files
    "*.log"
    "*/logs"

    # Large media that's usually backed up elsewhere
    "*.iso"
    "*.dmg"
    "*.img"

    # Virtual machines
    "*.qcow2"
    "*.vdi"
    "*.vmdk"
    "*/VirtualBox VMs"

    # Steam and games
    "*/Games"
    "*/.steam"
    "*/.local/share/Steam"

    # Downloads folder
    "*/Downloads"
  ];

  excludeArgs = map (exclude: "--exclude=${exclude}") defaultExcludes;

  # Get users that have backup enabled
  usersWithBackup = filterAttrs (name: user: user.backups.enable) config.users.users;
in
{
  # Extend the users.users submodule to add backup options
  options.users.users = mkOption {
    type = types.attrsOf (
      types.submodule {
        options.backups = {
          enable = mkEnableOption "home directory backup for this user";
        };
      }
    );
  };

  config = mkIf (usersWithBackup != { }) {
    services.resticBackup.enable = true;

    services.resticBackup.backups = listToAttrs (
      mapAttrsToList (username: user: {
        name = "home-${username}";
        value = {
          enable = true;
          paths = [ "/home/${username}" ];
          extraArgs = excludeArgs;
        };
      }) usersWithBackup
    );
  };
}
