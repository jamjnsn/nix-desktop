{ config, pkgs, ... }:
{
  # Nix CLI tool
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };

    flake = "$HOME/.nixos";
  };

  # Utilities
  home.packages = with pkgs; [
    nix-output-monitor
    nvd # Diff tool
    nixd # Nix LSP
    nil # Alternative Nix LSP
    nixfmt-rfc-style # Nix formatter
  ];
}
