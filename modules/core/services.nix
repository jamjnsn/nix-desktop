{ lib, ... }:
{
  services = {
    gvfs.enable = true;
    printing.enable = true;

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
