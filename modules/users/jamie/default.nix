{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ../../home
  ];

  # Fonts
  fonts.fontconfig.enable = true;

  # Flatpaks
  services.flatpak.enable = true;
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

    python3

    fzf
    zoxide
    yt-dlp
    tdrop

    samba

    alpaca # AI chat client
    smile # Emoji picker

    # Network utilities
    traceroute
    dig # Also contains nslookup

    # Fonts
    nerd-fonts.jetbrains-mono
  ];

  # Add .local/bin to PATH
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
  };

  # Add scripts folder
  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
    executable = true;
  };
}
