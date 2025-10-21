# While nix does provide services.ollama, the default configuration doesn't work well with btrfs.
#
# We want ollama to have its own subvol so it's excluded from system snapshots, but btrfs creates the
# subvol with root:root ownership. We can't use a postCreateHook in disko because the ollama user and
# group will not exist at that point, so we need to ensure ownership some other way. In this case,
# we make /var/lib/ollama the home for our ollama user, so permissions are handled.
#
# The nix-provided service uses a dynamic user, which isn't convenient to work with to ensure the
# permissions are set on the subvolume, so it's not a great option.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    ollama
  ];

  systemd.services.ollama = {
    description = "Ollama LLM Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    environment = {
      OLLAMA_MODELS = "/var/lib/ollama/models";
      OLLAMA_HOST = "0.0.0.0:11434";
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "always";
      RestartSec = 3;
      User = "ollama";
      Group = "ollama";
    };
  };

  users.users.ollama = {
    isSystemUser = true;
    group = "ollama";
    home = "/var/lib/ollama";
    createHome = true;
  };

  users.groups.ollama = { };
}
