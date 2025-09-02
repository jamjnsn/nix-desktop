{ pkgs, lib, ... }:
{
  environment.gnome.excludePackages = with pkgs; [
    epiphany # Web browser
    yelp # Help viewer
    geary # Email client
    seahorse # Password manager
    gnome-terminal
  ];

  services.xserver.desktopManager.gnome.enable = lib.mkDefault true;
}
