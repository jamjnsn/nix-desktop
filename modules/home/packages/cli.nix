{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Utils
    htop
    jq
    samba
    grc # colorizer

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
