{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    desktop.gnome.enable = mkEnableOption "GNOME desktop environment";
  };

  config = mkIf config.desktop.gnome.enable {
    # home-manager = {
    #   sharedModules = [
    #     ./home
    #   ];
    # };

    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # Add GNOME-specific portal
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

    environment.gnome.excludePackages = with pkgs; [
      epiphany # Web browser
      yelp # Help viewer
      geary # Email client
      seahorse # Password manager
      gnome-terminal
      gnome-system-monitor # Using Resources instead
    ];

    environment.systemPackages = with pkgs; [
      gnome-software
      resources
    ];

    # Somewhat hacky script to copy monitor config from the primary user so GDM fully respects that monitor configuration.
    systemd.services.copy-monitors-to-gdm = {
      description = "Copy monitors.xml to GDM config";
      after = [
        "network.target"
        "systemd-user-sessions.service"
        "display-manager.service"
      ];
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "copy-monitors-to-gdm.sh" ''
          #!${pkgs.bash}/bin/bash

          set -euo pipefail

          monitorsFile="/home/jamie/.config/monitors.xml"

          if ! [ -f "$monitorsFile" ]; then
            echo "Monitor configuration file not found. Not copying."

            # It's not an error if the file doesn't exist. In a single monitor setup this file doesn't necessarily exist.
            exit 0
          fi

          mkdir -p /run/gdm/.config
          cp /home/jamie/.config/monitors.xml /run/gdm/.config/monitors.xml
          chown gdm:gdm /run/gdm/.config/monitors.xml
        '';
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
