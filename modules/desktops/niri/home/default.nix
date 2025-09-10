{ pkgs, ... }:
{
  # imports = [
  #   ./wofi.nix
  #   ./waybar.nix
  #   ./hyprlock.nix
  # ];

  home.packages = with pkgs; [
    wofi
    waybar
    hyprlock
    hyprpaper
  ];

  home.file.".config/niri/config.kdl".source = ./config.kdl;
}
