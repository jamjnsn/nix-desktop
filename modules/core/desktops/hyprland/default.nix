{
  pkgs,
  config,
  lib,
  ...
}:
{
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    enable = true;

    displayManager = {
      gdm.enable = true;
    };
  };

  services.displayManager.sessionPackages = with pkgs; [ hyprland ];

  programs.hyprland = {
    enable = lib.mkDefault true;
    xwayland.enable = true;
  };
}
