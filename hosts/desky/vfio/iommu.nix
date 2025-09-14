{ lib, config, ... }:
let
  vmConfig = config.vmConfig;
in
{
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
      options vfio-pci ids=${lib.concatStringsSep "," vmConfig.isolatePcieIds}
    '';
  };
}
