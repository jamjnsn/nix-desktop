{ config, pkgs, ... }:
{
  # Allows reading .envrc to load environment variables
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableZshIntegration = true;

  # Development tools
  home.packages = with pkgs; [
    nixd              # Nix LSP
    nil               # Alternative Nix LSP
    nixfmt-rfc-style  # Nix formatter
  ];

  # VScode
  programs.vscode = {
    enable = true;
  };

  # Git
  programs.git = {
    enable = true;
    userName = "Jamie";
    userEmail = "jamie@jnsn.me";
  };
}
