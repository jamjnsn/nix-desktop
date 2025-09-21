{ ... }:
{
  imports = [
    ./desktops

    ./agenix.nix
    ./boot.nix
    ./disk-config.nix
    ./docker.nix
    # ./efi-shell.nix # Don't really need this to be always available
    ./flatpak.nix
    ./gaming.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    # ./ollama.nix # It's not working right anyways
    ./performance.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./sound.nix
    ./system.nix
    ./users.nix
    ./virtualization.nix
  ];
}
