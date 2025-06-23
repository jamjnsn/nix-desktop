{ config, lib, pkgs, ... }:

{
  imports = [
    ./disk-config.nix
    ./modules/gnome.nix
  ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-public-keys =
    [ "desky:WnCW8C/gDmA7lqW3uzAW3Bw7qvW0hTX3NepWifDJybY=%" ];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "zfs" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Tweaks
  security.rtkit.enable = true; # hands out realtime scheduling priority to processes that ask for it.

  # Enable tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  services.tailscale.extraUpFlags =
    [ "--ssh" "--advertise-exit-node" "--advertise-tags=tag:server" ];
  networking.firewall.checkReversePath =
    "loose"; # https://github.com/tailscale/tailscale/issues/4432#issuecomment-1112819111
  services.resolved.enable =
    true; # https://github.com/tailscale/tailscale/issues/4254
  # TODO: Apply this fix: https://tailscale.com/kb/1320/performance-best-practices#ethtool-configurationhttps://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ ];
  };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Sound
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

  # Create admin user with default password
  users.mutableUsers = false;
  users.users.jamie = {
    description = "Jamie";
    home = "/home/jamie";
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "podman" "storage" ];
    hashedPassword = "$6$bNA3pkIN8HqDgv2H$s50wORlm48JP/dwzHZAhDU8c5DToBluyCMd3f.IlTnOJ87js6Cw0KS3D40tRNvoslFV8oHBJfk8JNipjVVzvq1"; # empty password
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG/Ktp96ldlqZwoH4dGQl6uBLBF3i8xLbnF4PAS+gJx jamie@desky"
    ];
  };

  programs.firefox.enable = true;

  # Flatpak
  services.flatpak = {
    enable = true;
    overrides = {
      global = {
        Environment = {
          GTK_THEME = "Adwaita:dark";
        };
      };
    };
  };

  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "daily";
  };

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  environment.variables.EDITOR = "nano";
  programs.nix-ld.enable = true; # For VS Code attaching

  # Set NixOS version
  system.stateVersion = "25.05";
}
