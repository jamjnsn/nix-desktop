# nix-desktop

Nix config for my personal computers. This is currently designed for a single user configuration.

## Secrets

Secrets are managed with `sops-nix`. Ensure the private key is located at `~/.config/sops/age/keys.txt`.

## Installation

This configuration can be installed to a remote machine using `nixos-anywhere`.

1. Boot into a full NixOS graphical installer and connect to the local network.
2. Set a root password:
   ```sh
   sudo passwd
   ```
3. Install (and generate a new hardware-configuration.nix):
   ```sh
   nixos-anywhere --generate-hardware-config nixos-generate-config ./hosts/lappy/hardware-configuration.nix --flake '.#lappy' --target-host root@10.0.0.66
   ```
4. SSH into the host and connect to Tailscale:
   ```
   tailscale up --operator=jamie
   ```
5. A full rebuild is required to ensure all configuration is correctly deployed:
   ```
   nixos-rebuild switch --flake '.#lappy' --verbose --use-remote-sudo --target-host jamie@lappy
   ```
6. Enroll the TPM key for the root disk device:
   ```
   sudo systemd-cryptenroll --tpm2-device=auto /dev/disk/by-id/<disk ID here>-part2
   ```

## Applying Configuration

### dconf

Using dconf2nix, you can create a .nix file to reproduce your current dconf settings. Presently, it's preferred to add specific settings to users/modules/dconf.nix.

### Disk Layout (including BTRFS subvolumes)

Any changes to disk layout, including the addition of new BTRFS subvolumes, will need to be manually applied to the system. The changes should be added to disko configuration for future reinstallation.