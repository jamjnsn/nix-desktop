{ pkgs, inputs, ... }:
{
  imports = [ inputs.agenix.nixosModules.default ];

  age.secrets.env-jamie = {
    file = ../../secrets/env-jamie.age;
    mode = "400";
    owner = "jamie";
  };

  age.secrets.samba-mox = {
    file = ../../secrets/samba-mox.age;
    mode = "400";
    owner = "jamie";
  };

  age.secrets.restic-password = {
    file = ../../secrets/restic-password.age;
    mode = "400";
    owner = "jamie";
  };
}
