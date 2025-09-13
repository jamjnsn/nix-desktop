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
    ];

    environment.systemPackages = with pkgs; [
      gnome-software
    ];
  };
}
