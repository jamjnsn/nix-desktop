{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    podman
    podman-compose
    podman-tui
    pods
    dive
  ];

  # Enable docker.io as a search registry
  home.file.".config/containers/registries.conf".text = ''
    [registries.search]
    registries = ['docker.io']
  '';

  home.file.".config/containers/policy.json".text = ''
    {
      "default": [
        { "type": "insecureAcceptAnything" }
      ]
    }
  '';
}
