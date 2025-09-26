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

  networking = {
    hostId = host.id;
    hostName = host.name;

    networkmanager = {
      enable = true;
      unmanaged = [
        "interface-name:br0"
      ]
      ++ (map (iface: "interface-name:${iface}") host.bridgeInterfaces);
    };

    bridges = {
      br0 = {
        interfaces = host.bridgeInterfaces;
      };
    };

    interfaces = {
      br0 = {
        useDHCP = true;
      };
    };

    nameservers = [
      # Quad9
      "9.9.9.9"
      "149.112.112.112"
    ];

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
