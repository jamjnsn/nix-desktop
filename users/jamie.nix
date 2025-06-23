# flake-inputs accesses inputs from flake.nix

{ config, pkgs, flake-inputs, ... }:

{
  home.username = "jamie";
  home.homeDirectory = "/home/jamie";

  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak

    ./modules/podman.nix
    ./modules/gnome.nix
  ];

  services.flatpak.packages = [
    "com.discordapp.Discord"
    "com.spotify.Client"
  ];

  home.stateVersion = "25.05";
}
