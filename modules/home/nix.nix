{
  config,
  pkgs,
  host,
  ...
}:
{
  # Nix CLI tool
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };

    flake = "$HOME/.nixos";
  };

  # Utilities
  home.packages = with pkgs; [
    nix-output-monitor
    nvd # Diff tool
    nixd # Nix LSP
    nil # Alternative Nix LSP
    nixfmt-rfc-style # Nix formatter
  ];

  # Generate cache keys if they don't exist
  home.activation.generateNixCacheKeys = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -s "$HOME/.config/nix/cache-priv-key.pem" ] || [ ! -s "$HOME/.config/nix/cache-pub-key.pem" ]; then
      echo "Generating user Nix binary cache signing keys..."
      ${pkgs.nix}/bin/nix-store --generate-binary-cache-key $(${pkgs.nettools}/bin/hostname)-${config.home.username} \
        "$HOME/.config/nix/cache-priv-key.pem" \
        "$HOME/.config/nix/cache-pub-key.pem"
      chmod 600 "$HOME/.config/nix/cache-priv-key.pem"
      chmod 644 "$HOME/.config/nix/cache-pub-key.pem"
    fi
  '';

  # Configure nix to use the signing key
  home.file.".config/nix/nix.conf".text = ''
    secret-key-files = ${config.home.homeDirectory}/.config/nix/cache-priv-key.pem
  '';
}
