{ config, pkgs, ... }:
{
  # Add user to libvirtd group
  users.users.jamie.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
  ];

  # Manage the virtualisation services
  virtualisation = {
    waydroid.enable = true;

    libvirtd = {
      enable = true;

      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;

  # Per-domain drop-in hooks
  environment.etc."libvirt/hooks/qemu" = {
    text = ''
      #!/usr/bin/env bash

      LOG_FILE="/tmp/libvirt-hooks.log"
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] Executing hook for $DOMAIN_NAME with args: $*" | tee -a "$LOG_FILE"

      DOMAIN_NAME="$1"
      DOMAIN_HOOK="/etc/libvirt/hooks/qemu.d/$DOMAIN_NAME"
      if [ -x "$DOMAIN_HOOK" ]; then
          exec "$DOMAIN_HOOK" "$@" 2>&1 | tee -a "$LOG_FILE"
      else
          echo "No hook found" | tee -a "$LOG_FILE"
      fi
    '';
    mode = "0755";
  };

  systemd.services.libvirtd.restartTriggers = [
    config.environment.etc."libvirt/hooks/qemu".source
  ];
}
