{
  config,
  lib,
  pkgs,
  rootDisk,
  ...
}:

{
  # Services
  services.fstrim.enable = lib.mkDefault true;
  services.printing.enable = true;
  services.avahi.enable = true;
  services.libinput.enable = true;
  services.gvfs.enable = true;
  services.tailscale.enable = true;

  # Gaming
  programs.gamemode.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ ];
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112" # Quad9
  ];

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Sound
  security.rtkit.enable = true; # hands out realtime scheduling priority to processes that ask for it.

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Firmware
  services.fwupd.enable = true;

  # Enable SSH access
  services.openssh = {
    openFirewall = true; # Access will be via Tailscale
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "jamie" ];
    };
  };

  # Programs
  programs.zsh.enable = true;
  virtualisation.waydroid.enable = true;
  programs.adb.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Utilities
    nano
    wget
    curl
    tree
    zsh
    git
    htop

    usbutils
    pciutils
    psmisc # killall and fuser
    lsof

    # Archive tools
    zip
    p7zip
    unzip
  ];

  # Default editor
  environment.variables.EDITOR = "nano";

  # Fonts
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      cantarell-fonts
      nerd-fonts.jetbrains-mono
    ];
  };

  # Set NixOS version
  system.stateVersion = "25.05";
}
