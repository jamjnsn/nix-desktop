{ config, pkgs, flake-inputs, ... }:
{
  imports = [
    flake-inputs.vscode-server.homeModules.default
  ];

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
  services.vscode-server.enable = true;
  programs.vscode = {
    enable = true;
  };

  # Git
  programs.git = {
    enable = true;
    userName = "Jamie Jansen";
    userEmail = "jamie@jnsn.me";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
