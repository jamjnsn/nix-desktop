{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Utils
    fzf
    htop
    jq
    samba

    # Alternatives
    ncdu
    bat # cat
    fd # find
    zoxide # cd
    ripgrep # grep
    duf # df

    # Networking
    traceroute
    dig
    gping
  ];
}
