{ ... }:
{
  hardware = {
    enableRedistributableFirmware = true;

    i2c.enable = true; # For hardware sensors

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
