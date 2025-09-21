{ lib, desktop, ... }:
{
  imports = [
    ./desktops
    ./navi
    ./packages
    ./zsh

    ./dev.nix
    ./distrobox.nix
    ./eza.nix
    ./firefox.nix
    ./fonts.nix
    ./fzf.nix
    ./ghostty.nix
    ./gomi.nix
    # ./kitty.nix
    ./mcfly.nix
    ./micro.nix
    ./nix.nix
    #./podman.nix
    ./tealdeer.nix
    ./tmux.nix
    ./yt-dlp.nix
    ./zoxide.nix
  ];
}
