{
  config,
  lib,
  pkgs,
  rootDisk,
  ...
}:

{
  # System packages
  environment.systemPackages = with pkgs; [
    # Utilities
    nano
    wget
    curl
    tree
    git
    htop

    usbutils
    pciutils
    psmisc # killall and fuser
    lsof

    # Archive tools
    zip
    p7zip
    unzip
  ];

  environment.variables.EDITOR = "nano";

  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
