{
  config,
  lib,
  pkgs,
  ...
}:
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

    # Disable history since I'm using atuin
    historySubstringSearch.enable = false;
    history = {
      size = 0;
      save = 0;
      path = "/dev/null";
    };

    initContent = lib.concatStringsSep "\n" [
      # Extra config in .zsh files for syntax highlighting
      (builtins.readFile ./options.zsh)
      (builtins.readFile ./functions.zsh)
      (builtins.readFile ./aliases.zsh)
      (builtins.readFile ./prompt.zsh)
    ];
  };
}
