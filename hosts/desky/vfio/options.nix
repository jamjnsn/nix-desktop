{ lib, ... }:

{
  options.vmConfig = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Name of the virtual machine";
    };

    ramGb = lib.mkOption {
      type = lib.types.int;
      description = "Amount of RAM in GB to allocate to the VM";
    };

    guestCores = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "List of CPU cores to dedicate to the guest VM";
    };

    isolatePcieIds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of PCIe device IDs to isolate for GPU passthrough";
    };
  };
}
