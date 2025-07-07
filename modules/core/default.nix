{ ... }:
{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./disk-config.nix
    # ./efi-shell.nix # Don't really need this to be always available
    ./flatpak.nix
    ./hardware.nix
    ./networking.nix
    ./nix.nix
    ./ollama.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./sound.nix
    ./system.nix
    ./users.nix
    ./virtualization.nix
  ];
}
