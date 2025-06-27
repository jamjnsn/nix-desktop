{ config, lib, pkgs, inputs, disko, ... }:
{
  networking.hostName = "desky";
  networking.hostId = "3e7b3b0b";

  imports = [
    (import ../common/disk-config.nix { 
      inherit lib; 
      rootDisk = "/dev/disk/by-id/nvme-CT2000P3SSD8_2311E6BBF76F"; 
    })

    ./hardware-configuration.nix
  ];

  boot.blacklistedKernelModules = [ "amdgpu" "radeon" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  services.xserver.videoDrivers = [ "nvidia" ];

  # Dual boot
  # boot.loader.systemd-boot.windows = {
  #   "windows" = {
  #     title = "Windows 11";
  #     efiDeviceHandle = "FS1"; # Adjust this to match your system's EFI mapping
  #     sortKey = "z_windows";
  #   };
  # };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
 
  hardware.nvidia = {
    modesetting.enable = true; # Required

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
