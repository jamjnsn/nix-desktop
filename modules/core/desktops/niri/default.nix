{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    desktop.niri.enable = mkEnableOption "Niri-based desktop environment";
  };

  config = mkIf config.desktop.niri.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
    };

    environment.systemPackages = with pkgs; [
      niri
    ];

    security.pam.services.swaylock = { };

    services.displayManager.sessionPackages = with pkgs; [
      niri
    ];
  };
}
