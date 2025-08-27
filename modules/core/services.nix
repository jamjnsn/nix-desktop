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
    };
  };
}
