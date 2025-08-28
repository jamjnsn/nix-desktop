{ pkgs, inputs, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  age.secrets.env-jamie = {
    file = ../../secrets/env-jamie.age;
    mode = "400";
    owner = "jamie";
  };
}
