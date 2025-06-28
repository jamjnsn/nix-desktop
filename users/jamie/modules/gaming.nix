{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    wineWowPackages.staging # Latest Wine for Windows games
    winetricks # Helper for Wine
    bottles # Wine prefix manager

    steam # Steam client
    lutris # Game launcher for Wine/retro games

    mangohud # Performance overlay for Vulkan/OpenGL
    gamemode # Feral Interactive's game mode daemon
    vkBasalt # Vulkan post-processing layer
    goverlay # GUI for MangoHud and vkBasalt
  ];
}
