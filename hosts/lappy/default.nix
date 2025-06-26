{ config, lib, pkgs, inputs, disko, ... }:
{
  networking.hostName = "lappy";
  networking.hostId = "3e7b3b0a";

  imports = [
    (import ../common/disk-config.nix { 
      inherit lib; 
      rootDisk = "/dev/disk/by-id/nvme-LENSE30256GMSP34MEAT3TA_1304720404575"; 
    })

    ./hardware-configuration.nix
  ];

  # Graphics
  boot.initrd.kernelModules = [ "i915" ];

  boot.kernelParams = [
    "i915.enable_guc=2"
    "i915.enable_fbc=1"
    "i915.enable_psr=2"
  ];

  services.xserver.videoDrivers = [ "intel" ];

  hardware.opengl = {
    enable = true;
    
    extraPackages = with pkgs; [
      intel-media-driver  # For Broadwell and newer CPUs
      intel-vaapi-driver  # For older Intel GPUs or for compatibility with some apps
      libvdpau-va-gl
    ];
  };

  # Intel microcode
  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  # Enable throttled
  services.throttled.enable = true;

  # Use TLP for power management
  services.power-profiles-daemon.enable = false;

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
