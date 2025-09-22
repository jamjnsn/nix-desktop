{ pkgs, host, ... }:
{
  # TPM
  security.tpm2.enable = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "nfs" ];

    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };

    # Set root disk for LUKS
    initrd.luks.devices.root.device = host.rootDisk;

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    plymouth = {
      enable = true;
      theme = "bgrt";
      font = "${pkgs.cantarell-fonts}/share/fonts/cantarell/Cantarell-VF.otf";
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
    };
  };
}
