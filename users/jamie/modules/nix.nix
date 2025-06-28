{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-output-monitor
    nixd # Nix LSP
    nil # Alternative Nix LSP
    nixfmt-rfc-style # Nix formatter
  ];

  # Nix CLI helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/user/my-nixos-config";
  };

}
