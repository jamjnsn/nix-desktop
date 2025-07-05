{ pkgs }:
{
  environment.systemPackages = with pkgs; [
    edk2-uefi-shell
  ];

  # Add EFI shell boot entry
  boot.loader.systemd-boot.extraEntries = {
    "efi-shell.conf" = ''
      title EFI Shell
      efi /EFI/tools/Shell.efi
    '';
  };

  # Copy EFI file from pkg
  system.activationScripts.efi-shell = ''
    if [ -d /boot/EFI ]; then
      mkdir -p /boot/EFI/tools
      cp ${pkgs.edk2-uefi-shell}/shell.efi /boot/EFI/tools/Shell.efi
    fi
  '';
}
