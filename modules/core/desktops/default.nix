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
