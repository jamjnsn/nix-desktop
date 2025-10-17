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

    systemd.services.copyGdmMonitorsXml = {
      description = "Copy monitors.xml to GDM config";
      after = [
        "network.target"
        "systemd-user-sessions.service"
        "display-manager.service"
      ];
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p /run/gdm/.config && cp /home/jamie/.config/monitors.xml /run/gdm/.config/monitors.xml && chown gdm:gdm /run/gdm/.config/monitors.xml'";
        Type = "oneshot";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
