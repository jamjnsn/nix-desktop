{ host, ... }:
{
  services.tailscale.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  networking = {
    hostId = host.id;
    hostName = host.name;

    networkmanager.enable = true;

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
