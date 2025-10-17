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
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s
    ./hardware-configuration.nix
    ../../modules/core
  ];

  desktop.gnome.enable = true;
  desktop.niri.enable = true;

  boot.initrd.kernelModules = [ "i915" ]; # Needed for early graphics, e.g. LUKS prompt

  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver # VA-API driver
    ];
  };

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
