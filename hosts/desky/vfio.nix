# VFIO-ready configuration using iGPU for the host and frees up the dGPU for passthrough
{
  config,
  lib,
  pkgs,
  host,
  ...
}:
{
  # VFIO
  boot = {
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "rd.driver.pre=vfio-pci"
    ];

    initrd.kernelModules = [
      "vfio"
      "vfio_iommu_type1"
      "vfio_pci"
    ];

    # Prevent NVIDIA drivers entirely
    blacklistedKernelModules = [
      "nvidia"
      "nouveau"
    ];

    # Isolate PCIe devices for VFIO
    extraModprobeConfig = ''
      options vfio-pci ids=10de:1e84,10de:10f8,10de:1ad8,10de:1ad9
    '';
  };
}
