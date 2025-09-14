# VFIO-ready configuration using iGPU for the host and frees up the dGPU for passthrough
{
  config,
  lib,
  pkgs,
  host,
  ...
}:
{
  imports = [
    ./hooks.nix
    ./hugepages.nix
    ./iommu.nix
    ./looking-glass.nix
    ./options.nix
  ];

  vmConfig = {
    name = "win11";
    ramGb = 8;

    guestCores = [
      4
      5
      6
      7
      12
      13
      14
      15
    ];

    isolatePcieIds = [
      "10de:1e84"
      "10de:10f8"
      "10de:1ad8"
      "10de:1ad9"
    ];
  };
}
