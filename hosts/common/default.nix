{ config, lib, pkgs, rootDisk, ... }:

{
  imports = [
    ./disk-config.nix
    ./programs/gnome.nix
  ];

  # Enable flakes
  nix = {
    settings = {
      download-buffer-size = 524288000; # 500 MiB (in bytes)
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];

      # NixOS binary cache
      substituters = [
        "https://cache.nixos.org/"
      ];

      # Public keys for pushing builds
      trusted-public-keys = [ 
        "desky:WnCW8C/gDmA7lqW3uzAW3Bw7qvW0hTX3NepWifDJybY=%"             # Desky WSL
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="  # NixOS binary cache
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

  # TPM
  security.tpm2.enable = true;
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.tpm2.enable = true;

  # Boot settings
  boot = {
    # Loader settings
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];

    plymouth = {
      enable = true;
      theme = "bgrt";
      font = "${pkgs.cantarell-fonts}/share/fonts/cantarell/Cantarell-VF.otf";
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
    };
  };

  # Tweaks
  services.fstrim.enable = lib.mkDefault true;
  services.printing.enable = true;
  services.avahi.enable = true;
  programs.gamemode.enable = true;

  # Enable Tailscale
  services.tailscale.enable = true;

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ ];
  };

  # Networking
  networking.networkmanager.enable = true;
  networking.nameservers = [ 
    "9.9.9.9" "149.112.112.112" # Quad9
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

  # Create admin user with default password
  users.mutableUsers = false; # Disable password changes
  
  users.users.jamie = {
    description = "Jamie";
    home = "/home/jamie";
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPassword = "$6$bNA3pkIN8HqDgv2H$s50wORlm48JP/dwzHZAhDU8c5DToBluyCMd3f.IlTnOJ87js6Cw0KS3D40tRNvoslFV8oHBJfk8JNipjVVzvq1"; # empty password
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG/Ktp96ldlqZwoH4dGQl6uBLBF3i8xLbnF4PAS+gJx jamie@desky" # WSL
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwFbe6YCNc/WHQRnCsrZu6NH8ny585VBrRzMJpB/mmW jamie@lappy"
    ];
  };

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

  # Programs
  programs.zsh.enable = true;
  programs.firefox.enable = true;
  virtualisation.waydroid.enable = true;

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
