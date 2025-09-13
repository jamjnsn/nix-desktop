{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./gnome
    ./niri
  ];

  # Shared desktop configuration that both GNOME and Plasma can use
  fonts.fontconfig.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    config = {
      common.default = [ "gtk" ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.xserver.enable = true;
}
