{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Utils
    htop
    jq
    samba
    grc # colorizer
    wl-clipboard

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

    # TUIs
    yazi # File manager
  ];
}
