{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  boot.initrd.kernelModules = [ "i915" ];
}
