# flake-inputs accesses inputs from flake.nix

{ config, pkgs, flake-inputs, ... }:

{
  home.username = "jamie";
  home.homeDirectory = "/home/jamie";

  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak

    ./modules/podman.nix
    ./modules/distrobox.nix
    ./modules/gnome.nix
    ./modules/dconf.nix
    ./modules/zsh.nix
    ./modules/kitty.nix
  ];

  # Fonts
  fonts.fontconfig.enable = true;

  # Flatpaks
  services.flatpak.packages = [
    "com.discordapp.Discord"
    "com.spotify.Client"
    "md.obsidian.Obsidian"
    "com.github.tchx84.Flatseal"
    "org.gnome.World.PikaBackup"
    "com.visualstudio.code"
    "md.obsidian.Obsidian.desktop"
  ];

  # Packages
  home.packages = with pkgs; [
    bat     # cat alternative
    eza     # ls alternative
    fzf
    zoxide
    tldr
    gomi    # Trash CLI
    yt-dlp
    tdrop

    # Network utilities
    traceroute
    dig     # Also contains nslookup
  ];

  # Add .local/bin to PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Add scripts folder
  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
  };

  # NixOS version
  home.stateVersion = "25.05";
  
  # Allow home-manager to manage itself
  programs.home-manager.enable = true;
}
