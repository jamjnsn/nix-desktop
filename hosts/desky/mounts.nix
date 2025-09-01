{ lib, ... }:

let
  mkSambaMount =
    {
      source,
      mountPoint,
      credentialsFile ? "/run/agenix/samba-mox",
    }:
    {
      tmpfiles = "d ${mountPoint} 0755 root root -";

      mount = {
        what = source;
        where = mountPoint;
        type = "cifs";
        options = "credentials=${credentialsFile},uid=1000,gid=100,iocharset=utf8,file_mode=0664,dir_mode=0775,vers=3.0";
        wantedBy = [ "multi-user.target" ];
      };

      automount = {
        where = mountPoint;
        wantedBy = [ "multi-user.target" ];
        automountConfig = {
          TimeoutIdleSec = "600";
        };
      };
    };

  # Define your mounts here
  mounts = [
    {
      source = "//mox/tank";
      mountPoint = "/mnt/tank";
    }
    {
      source = "//mox/dump";
      mountPoint = "/mnt/dump";
    }
  ];

  sambaMounts = map mkSambaMount mounts;
in

{
  systemd.tmpfiles.rules = map (m: m.tmpfiles) sambaMounts;
  systemd.mounts = map (m: m.mount) sambaMounts;
  systemd.automounts = map (m: m.automount) sambaMounts;
}
