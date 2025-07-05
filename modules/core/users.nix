{ pkgs, ... }:
{

  # Create admin user with default password
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
    hashedPassword = "$6$bNA3pkIN8HqDgv2H$s50wORlm48JP/dwzHZAhDU8c5DToBluyCMd3f.IlTnOJ87js6Cw0KS3D40tRNvoslFV8oHBJfk8JNipjVVzvq1"; # empty password
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICG/Ktp96ldlqZwoH4dGQl6uBLBF3i8xLbnF4PAS+gJx jamie@desky" # WSL
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwFbe6YCNc/WHQRnCsrZu6NH8ny585VBrRzMJpB/mmW jamie@lappy"
    ];
  };
}
