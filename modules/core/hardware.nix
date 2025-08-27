{ ... }:
{
  hardware = {
    i2c.enable = true; # For hardware sensors
    steam-hardware.enable = true; # Steam input support

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
