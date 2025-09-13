{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users.mutableUsers = false; # Disable password changes

  users.users.jamie = {
    description = "Jamie";
    home = "/home/jamie";
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPassword = "$6$bNA3pkIN8HqDgv2H$s50wORlm48JP/dwzHZAhDU8c5DToBluyCMd3f.IlTnOJ87js6Cw0KS3D40tRNvoslFV8oHBJfk8JNipjVVzvq1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG/Ktp96ldlqZwoH4dGQl6uBLBF3i8xLbnF4PAS+gJx jamie@desky" # WSL
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwFbe6YCNc/WHQRnCsrZu6NH8ny585VBrRzMJpB/mmW jamie@lappy"
    ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      desktop = config.desktop;
    };

    users.jamie = {
      imports = [ ../users/jamie ];
      home.username = "jamie";
      home.homeDirectory = "/home/jamie";
      home.stateVersion = "25.05";
      programs.home-manager.enable = true;
    };
  };
}
