{
  config,
  pkgs,
  lib,
  flake-inputs,
  ...
}:
let
  helpers = import ../../lib/helpers.nix { inherit pkgs lib; };
  modulePaths = helpers.importDir ./modules;
in
{
  home.username = "jamie";
  home.homeDirectory = "/home/jamie";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    overlays = [
      (import ../../overlays/product-sans.nix)
    ];
  };

  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ] ++ modulePaths;

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
    bat # cat alternative
    fd # find alternative
    gomi # Trash CLI

    fzf
    zoxide
    yt-dlp
    tdrop

    # Network utilities
    traceroute
    dig # Also contains nslookup

    # Fonts
    nerd-fonts.jetbrains-mono
    product-sans
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
