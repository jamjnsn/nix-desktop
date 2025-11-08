{
  lib,
  pkgs,
  host,
  ...
}:
{
  assertions = [
    {
      assertion = pkgs.tailscale.version == "1.82.5";
      message = ''
        REMOVE TEMPORARY FIX: Tailscale version has changed from 1.82.5 to ${pkgs.tailscale.version}.
        The portlist test issue may be fixed. Try removing the doCheck = false override.
        If tests pass, remove this assertion and the override.
      '';
    }
  ];

  services.tailscale = {
    enable = true;
    package = pkgs.tailscale.overrideAttrs (oldAttrs: {
      doCheck = false; # Temporary fix for portlist tests in 1.82.5 specifically
    });
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };

  networking = {
    hostId = host.id;
    hostName = host.name;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # Tailscale
        59010
        59011
      ];
      allowedUDPPorts = [
        # Tailscale
        59010
        59011
      ];
    };
  };
}
