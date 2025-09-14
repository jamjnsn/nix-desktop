{
  pkgs,
  config,
  ...
}:
let
  vmConfig = config.vmConfig;
in
{
  environment.etc."libvirt/hooks/qemu.d/${vmConfig.name}" = {
    text = ''
      #!/usr/bin/env bash

      ACTION="$2"

      if [ "$ACTION" = "started" ] || [ "$ACTION" = "prepare" ]; then
        echo "Creating shared memory for looking-glass"

        truncate -s 256M /dev/shm/looking-glass
        chown jamie:qemu-libvirtd /dev/shm/looking-glass
        chmod 660 /dev/shm/looking-glass

        echo "Isolating CPU cores for ${vmConfig.name}"
        
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
      elif [ "$ACTION" = "stopped" ] || [ "$ACTION" = "release" ]; then
        echo "Restoring CPU cores after ${vmConfig.name} shutdown"
            
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
      fi
    '';

    mode = "0755";
  };

  # Ensure libvirt service restarts to pick up the hooks
  systemd.services.libvirtd.restartTriggers = [
    config.environment.etc."libvirt/hooks/qemu.d/${vmConfig.name}".source
  ];
}
