{ config, pkgs, lib, flake-inputs, ... }:
let
  # Define GNOME extensions
  gnomeExtensions = with pkgs.gnomeExtensions; [
    blur-my-shell 
    caffeine 
    gsconnect 
    removable-drive-menu 
    user-themes
    tailscale-qs
    appindicator            # Tray icons
    just-perfection
    pip-on-top              # Allows PiP from Firefox to work in Wayland
    wtmb-window-thumbnails  # OnTopReplica
    dash-to-dock
  ];
in
{
  home.username = "jamie";
  home.homeDirectory = "/home/jamie";

  _module.args.gnomeExtensions = gnomeExtensions;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = [];
  };

  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    
    # TODO: Import automatically (*.nix, moduleName/default.nix)
    ./modules/dconf.nix
    ./modules/dev.nix
    ./modules/distrobox.nix
    ./modules/gaming.nix
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
    "page.tesk.Refine" # GNOME Tweaks alternative
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
