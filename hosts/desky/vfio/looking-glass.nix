{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];

  # Not needed for modern QEMU apparently
  # systemd.tmpfiles.rules = [
  #   "f /dev/shm/looking-glass 0660 jamie kvm - 256M"
  # ];
}
