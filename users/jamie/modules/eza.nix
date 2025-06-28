{
  programs.eza.enable = true;
  home.file.".config/eza/theme.yml".source = ../dotfiles/eza/one-dark.yml;
  programs.zsh.shellAliases = {
    ls = "eza --icons --group-directories-first";
  };
}
