{ config, ... }:
let
  vmConfig = config.vmConfig;
in
{
  boot.kernel.sysctl = {
    "vm.nr_overcommit_hugepages" = vmConfig.ramGb * 512; # 1GB = 512 * 2MB pages
  };

  fileSystems."/dev/hugepages" = {
    device = "hugetlbfs";
    fsType = "hugetlbfs";
    options = [ "mode=01777" ];
  };
}
