{
  config,
  lib,
  pkgs,
  inputs,
  disko,
  host,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
  ];

  desktop.gnome.enable = true;
  desktop.niri.enable = true;

  # Graphics
  boot.initrd.kernelModules = [ "i915" ];

  boot.kernelParams = [
    "i915.enable_guc=2"
    "i915.enable_fbc=1"
    "i915.enable_psr=2"
  ];

  services.xserver.videoDrivers = [ "intel" ];

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver # For Broadwell and newer CPUs
      intel-vaapi-driver # For older Intel GPUs or for compatibility with some apps
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
    powertop.enable = true; # Optimizes other components
  };

  fileSystems."/mnt/backups" = {
    device = "nyx:/storage/backups/jamie/lappy";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
    ];
  };

  services.resticBackup = {
    enable = true;
    schedule = "hourly";
  };

  users.users.jamie.backups.enable = true;
}
