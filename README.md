# nix-desktop

Nix config for my personal computers.

## Installation

This configuration can be installed to a remote machine using `nixos-anywhere`.

1. Boot into a full NixOS graphical installer and connect to the local network.
2. Set a root password:
   ```sh
   sudo passwd
   ```
3. Install:
   ```sh
   nixos-anywhere --generate-hardware-config nixos-generate-config ./hosts/lappy/hardware-configuration.nix --flake '.#lappy' --target-host root@10.0.0.66
   ```
4. SSH into the host and connect to Tailscale:
   ```
   tailscale up --operator=jamie
   ```
