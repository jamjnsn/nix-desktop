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

    # Network utilities
    traceroute
    dig # Also contains nslookup

    resources # System Monitor alternative
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
