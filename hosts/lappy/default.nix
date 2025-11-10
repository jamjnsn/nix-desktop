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
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
    ./hardware-configuration.nix
    ../../modules/core
  ];

  desktop.gnome.enable = true;
  desktop.niri.enable = true;

  boot.kernelParams = [
    "video=eDP-1:1920x1080@65"
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.dc=1"

    "amdgpu.runpm=1" # Runtime PM
    "amdgpu.bapm=1" # Battery power management
    "amdgpu.dpm=1" # Dynamic power management
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
    powertop.enable = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ]; # Needed for early graphics, e.g. LUKS prompt

  hardware.graphics = {
    extraPackages = with pkgs; [
      amdvlk
      mesa
      libva
      vaapiVdpau
    ];
  };

  services.power-profiles-daemon.enable = false;
  services.tlp = {
    enable = true;
    settings = {
      # CPU frequency scaling
      CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # AMD-specific
      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";

      # Renoir-specific: aggressive power saving
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # CPU boost control (big battery saver)
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0; # Disable boost on battery

      # Energy performance preference
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # USB autosuspend
      USB_AUTOSUSPEND = 1;

      # Runtime PM for devices
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";
    };
  };

  environment.systemPackages = with pkgs; [
    radeontop
    lm_sensors
  ];

  fileSystems."/mnt/backups" = {
    device = "nyx:/storage/backups/jamie/lappy";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "x-systemd.idle-timeout=60" # Unmount after 60 seconds of idle time
      "x-systemd.mount-timeout=10" # Timeout mount attempts after 10 seconds
      "_netdev"
      "noauto"
    ];
  };

  services.resticBackup = {
    enable = true;
  };

  users.users.jamie.backups.enable = true;
}
