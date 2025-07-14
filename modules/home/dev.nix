{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.vscode-server.homeModules.default
  ];

  # Allows reading .envrc to load environment variables
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableZshIntegration = true;

  # Development tools
  home.packages = with pkgs; [
    python3
    ansible
    just
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
