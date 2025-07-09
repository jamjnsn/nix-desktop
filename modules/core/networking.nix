{ host, ... }:
{
  services.avahi.enable = true;
  services.tailscale.enable = true;

  networking = {
    hostId = host.id;
    hostName = host.name;

    networkmanager.enable = true;

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
