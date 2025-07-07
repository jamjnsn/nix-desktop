{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yt-dlp
  ];

  programs.zsh.initContent = ''
    alias ytdl="yt-dlp -P ~/Downloads"
  '';
}
