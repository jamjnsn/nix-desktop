{ pkgs, ... }:
{
  home-manager = {
    sharedModules = [
      ./home
    ];
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    niri
  ];

  security.pam.services.swaylock = { };

  services.displayManager.sessionPackages = with pkgs; [
    niri
  ];

}
