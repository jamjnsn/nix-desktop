{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "always";
    colors = "always";
    git = true;

    extraOptions = [
      "--group-directories-first"
    ];
  };

  home.file.".config/eza/theme.yml".source = ../dotfiles/eza/theme.yml;
}
