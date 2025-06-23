# See: https://github.com/nix-community/disko/blob/master/example/zfs-encrypted-root.nix

{ lib, diskDevice, ... }: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = diskDevice;
        content = {
          type = "gpt";

          partitions = {

            ESP = {
              size = "4G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "4G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };

            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };

    zpool = {
      rpool = {
        type = "zpool";
        
        rootFsOptions = {
          atime = "off";
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "true";
        };
        
        options.ashift = "12";

        datasets = {
          "root" = {
            type = "zfs_fs";

            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              #keylocation = "file:///tmp/secret.key";
              keylocation = "prompt";
            };

            mountpoint = "/";
          };

          "nix" = {
            type = "zfs_fs";
            options.mountpoint = "/nix";
            mountpoint = "/nix";
          };

          "home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.relatime = "on";
          };
        };
      };
    };
  };
}
