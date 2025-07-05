{ ... }:
{
  imports = [
    ./disk-config.nix
    ./boot.nix
    # ./efi-shell.nix # Don't really need this
    ./nix.nix
    ./system.nix
    ./users.nix
    ./desktop.nix
    ./ollama.nix
  ];
}
