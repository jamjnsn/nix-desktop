{
  config,
  lib,
  pkgs,
  host,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ./vfio
    ./mounts.nix
    # ./nvidia.nix
  ];

  boot.loader.systemd-boot.windows = {
    "windows" = {
      title = "Windows 11";
      efiDeviceHandle = "FS1";
      sortKey = "0_windows";
    };
  };

  desktop.gnome.enable = true;
}
