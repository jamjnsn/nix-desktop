{ config, pkgs, lib, flake-inputs, ... }:
{
  home.username = "jamie";
  home.homeDirectory = "/home/jamie";

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [];
  };

  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    
    # TODO: Import automatically (*.nix, moduleName/default.nix)
    ./modules/dev.nix
    ./modules/distrobox.nix
    ./modules/gaming.nix
    ./modules/gnome.nix
    ./modules/kitty.nix
    ./modules/mcfly.nix
    ./modules/podman.nix
    ./modules/tealdeer.nix
    ./modules/zoxide.nix
    ./modules/zsh.nix
  ];

  # Fonts
  fonts.fontconfig.enable = true;

  # Flatpaks
  services.flatpak.packages = [
    "com.discordapp.Discord"
    "com.spotify.Client"
    "md.obsidian.Obsidian"
    "org.gnome.World.PikaBackup"
    "md.obsidian.Obsidian.desktop"
    "com.github.tchx84.Flatseal"
  ];

  # Packages
  home.packages = with pkgs; [
    bat     # cat alternative
    eza     # ls alternative
    fzf
    zoxide
    gomi    # Trash CLI
    yt-dlp
    tdrop

    # Network utilities
    traceroute
    dig     # Also contains nslookup

    # Fonts
    nerd-fonts.jetbrains-mono
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
