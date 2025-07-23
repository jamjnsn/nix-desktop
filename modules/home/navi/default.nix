{ config, pkgs, ... }:
{
  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      finder = {
        command = "fzf";
        overrides = "--height 50% --reverse --border --preview-window=right:50%";
      };
    };
  };

  home.file.".local/share/navi/cheats" = {
    source = ./cheats;
    recursive = true;
  };
}
