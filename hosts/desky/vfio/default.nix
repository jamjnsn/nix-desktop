# VFIO-ready configuration using iGPU for the host and frees up the dGPU for passthrough
{
  config,
  lib,
  pkgs,
  host,
  ...
}:
let
  vmName = "win11";
  hugepages = 8; # GB
in
{
  imports = [ ./looking-glass.nix ];

  boot = {
    kernel.sysctl = {
      "vm.nr_overcommit_hugepages" = hugepages * 512; # 1GB = 512 * 2MB pages
    };

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
    extraModprobeConfig =
      let
        vfioPciIds = [
          # NVIDIA 2070 SUPER
          "10de:1e84" # Video
          "10de:10f8" # Audio
          "10de:1ad8" # USB Controller
          "10de:1ad9" # Type-C Controller
        ];
      in
      ''
        options vfio-pci ids=${lib.concatStringsSep "," vfioPciIds}
        options kvmfr static_size_mb=128
      '';
  };

  fileSystems."/dev/hugepages" = {
    device = "hugetlbfs";
    fsType = "hugetlbfs";
    options = [ "mode=01777" ];
  };

  users.groups.kvm.members = [
    "jamie"
    "qemu-libvirtd"
  ];

  environment.etc."libvirt/hooks/qemu" = {
    text = ''
      #!{$pkgs.bash}/bin/bash

      # VM name is passed as $1, action as $2
      VM_NAME="$1"
      ACTION="$2"

      # Only apply to your gaming VM (change this to your VM name)
      if [ "$VM_NAME" != "${vmName}" ]; then
        exit 0
      fi

      if [ "$2" = "started" ] || [ "$2" = "prepare" ]; then
          systemctl start gaming-vm-start-hook
      elif [ "$2" = "stopped" ] || [ "$2" = "release" ]; then
          systemctl start gaming-vm-stop-hook
      fi
    '';

    mode = "0755";
  };

  systemd.services.gaming-vm-start = {
    description = "Isolate CPU cores for VM";
    script = ''
      echo "Isolating CPU cores for $VM_NAME"
          
      # Move systemd slices to host cores (0,1,2,3,8,9,10,11) - leaving cores 4-7,12-15 for VM
      systemctl set-property --runtime -- system.slice AllowedCPUs=0,1,2,3,8,9,10,11
      systemctl set-property --runtime -- user.slice AllowedCPUs=0,1,2,3,8,9,10,11
      systemctl set-property --runtime -- init.scope AllowedCPUs=0,1,2,3,8,9,10,11

      # Move IRQs away from VM cores to host cores (binary: 0000111100001111 = f0f)
      echo f0f > /proc/irq/default_smp_affinity

      # Set CPU governor to performance on VM cores (4-7,12-15)
      for cpu in {4..7} {12..15}; do
        echo "performance" > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor 2>/dev/null || true
      done

      echo "CPU isolation complete - VM cores 4-7,12-15 isolated"
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.gaming-vm-stop = {
    description = "Restore CPU cores after VM shutdown";
    script = ''
      echo "Restoring CPU cores after $VM_NAME shutdown"
          
      # Restore systemd slices to all cores (0-15)
      systemctl set-property --runtime -- system.slice AllowedCPUs=0-15
      systemctl set-property --runtime -- user.slice AllowedCPUs=0-15
      systemctl set-property --runtime -- init.scope AllowedCPUs=0-15

      # Restore IRQ affinity to all cores
      echo ffff > /proc/irq/default_smp_affinity

      # Restore CPU governor
      for cpu in {2..7} {10..15}; do
        echo "schedutil" > /sys/devices/system/cpu/cpu$cpu/cpufreq/scaling_governor 2>/dev/null || true
      done

      echo "CPU restoration complete"
    '';
    serviceConfig.Type = "oneshot";
  };

  # Ensure libvirt service restarts to pick up the hooks
  systemd.services.libvirtd.restartTriggers = [
    config.environment.etc."libvirt/hooks/qemu".source
  ];
}
