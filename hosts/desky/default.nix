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
    # ./vfio.nix
    ./nvidia.nix
  ];

  # Dual boot
  boot.loader.systemd-boot.windows = {
    "windows" = {
      title = "Windows 11";
      efiDeviceHandle = "FS1";
      sortKey = "z_windows";
    };
  };

}
