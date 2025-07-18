{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    autosuggestion = {
      enable = true;
    };

    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];

    sessionVariables = { };

    history.size = 10000;
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
      "ls *"
      "cd *"
      "mv *"
      "pwd *"
      "exit *"
      "ls *"
    ];

    # Extra config in .zsh files for syntax highlighting
    initContent = lib.concatStringsSep "\n" [
      (builtins.readFile ./options.zsh)
      (builtins.readFile ./functions.zsh)
      (builtins.readFile ./aliases.zsh)
      (builtins.readFile ./prompt.zsh)
    ];
  };
}
