{ lib, ... }:
{
  zramSwap = {
    enable = true;
    memoryPercent = 200; # Since ZRAM is compressed, we can allocate more than 100%
    algorithm = "zstd";
  };

  # Default to performance mode
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Limit journaling for better RAM usage and less disk writes
  services.journald = {
    rateLimitBurst = 1000;
    rateLimitInterval = "30s";
    extraConfig = ''
      Storage=auto
      SystemMaxUse=200M
      RuntimeMaxUse=50M
    '';
  };

  services.bpftune.enable = true; # Automatically tunes kernel parameters in real-time based on system behavior

  # Prevent nix-daemon from OOM killing other processes
  systemd = {
    slices."nix-daemon".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "95%";
    };
    services."nix-daemon" = {
      serviceConfig = {
        Slice = "nix-daemon.slice";
        OOMScoreAdjust = 1000;
      };
    };
  };
}
