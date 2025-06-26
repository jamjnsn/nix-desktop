{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
    ./hardware-configuration.nix
  ];

  boot.initrd.kernelModules = [ "i915" ];

  # Scattershot approach to fixing bad WiFi while still maintaining decent battery life below.
  services.power-profiles-daemon.enable = false; # nixos-hardware adds power-profiles-daemon which conflicts
  services.tlp = {
    enable = true;
    settings = {
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
    };
  };

  # Disable power management to avoid horrible WiFi
  networking.networkmanager.wifi.powersave = false;
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
    options iwlmvm power_scheme=1
  '';
  
  # Power management
  powerManagement = {
    enable = true;
    powertop.enable = true;  # Optimizes other components
  };
}
