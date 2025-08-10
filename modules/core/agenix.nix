{
  inputs,
  system,
  pkgs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];
}
