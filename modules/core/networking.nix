{ ... }:
{
  services.avahi.enable = true;
  services.tailscale.enable = true;

  networking = {
    networkmanager.enable = true;

    nameservers = [
      # Quad9
      "9.9.9.9"
      "149.112.112.112"
    ];

    # Firewall
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };
}
