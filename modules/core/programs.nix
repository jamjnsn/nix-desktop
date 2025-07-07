{ pkgs, ... }:
{
  programs = {
    gamemode.enable = true;
    dconf.enable = true;
    zsh.enable = true;
    adb.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
