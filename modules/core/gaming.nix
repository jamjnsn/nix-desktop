{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wineWowPackages.staging # Latest Wine for Windows games
    winetricks # Helper for Wine
    bottles # Wine prefix manager

    lutris # Game launcher for Wine/retro games

    mangohud # Performance overlay for Vulkan/OpenGL
    gamemode # Feral Interactive's game mode daemon
    vkBasalt # Vulkan post-processing layer
    goverlay # GUI for MangoHud and vkBasalt
  ];

  hardware.steam-hardware.enable = true; # Steam input support

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Steam Remote Play
  };
}
