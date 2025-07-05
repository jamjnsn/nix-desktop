{ ... }:
{
  # Enable flakes
  nix = {
    settings = {
      download-buffer-size = 524288000; # 500 MiB (in bytes)
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # NixOS binary cache
      substituters = [
        "https://cache.nixos.org/"
      ];

      # Public keys for pushing builds
      trusted-public-keys = [
        "desky:WnCW8C/gDmA7lqW3uzAW3Bw7qvW0hTX3NepWifDJybY=%" # Desky WSL
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" # NixOS binary cache
      ];

      # Faster rebuild
      builders-use-substitutes = true;
      max-jobs = "auto";
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
