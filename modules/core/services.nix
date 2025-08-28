{ lib, ... }:
{
  services = {
    gvfs.enable = true;
    printing.enable = true;
    locate.enable = true;
    udisks2.enable = true; # For automounting drives
    btrfs.autoScrub.enable = true;

    fstrim.enable = lib.mkDefault true;
    libinput.enable = true;
    fwupd.enable = true;

    openssh = {
      openFirewall = true;
      enable = true;
      ports = [ 22 ];

      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "jamie" ];
      };

      hostKeys = [
        {
          path = "/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };
  };
}
