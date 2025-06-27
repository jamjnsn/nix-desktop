{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;

    options = [
      # Replace cd with zoxide
      "--cmd cd"
    ];
  };
}