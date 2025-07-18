# TODO: Find another way to define rootdisk so this can be included in core modules
# See: https://github.com/nix-community/disko/blob/master/example/zfs-encrypted-root.nix

{ inputs, host, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = host.rootDisk;
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

            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                # passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  # keyFile = "/tmp/secret.key";
                };
                # additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "relatime"
                      ];
                    };

                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/ollama-models" = {
                      mountpoint = "/var/lib/ollama/models";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/libvirt-images" = {
                      mountpoint = "/var/lib/libvirt/images";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };

                    "/swap" = {
                      mountpoint = "/.swap";
                      swap.swapfile.size = "2G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };

    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=4G"
        ];
      };
    };
  };
}
