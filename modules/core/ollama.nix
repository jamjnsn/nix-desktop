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
