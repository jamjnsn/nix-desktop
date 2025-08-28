{ pkgs, ... }:
{
  users.users.jamie.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
    enableOnBoot = true;

    autoPrune = {
      enable = true;
      dates = "daily";
      flags = [ "--all" ];
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    lazydocker
  ];
}
