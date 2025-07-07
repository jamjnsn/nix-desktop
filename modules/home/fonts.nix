{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    emoji = [ "Twitter Color Emoji" ];
  };

  home.packages = with pkgs; [
    twemoji-color-font

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    liberation_ttf
    cantarell-fonts

    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];
}
