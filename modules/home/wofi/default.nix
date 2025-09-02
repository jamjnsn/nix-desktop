{ pkgs, ... }:
{
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_markup = true;
      no_actions = true;
      halign = "fill";
      orientation = "vertical";
      content_halign = "fill";
      insensitive = true;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
      matching = "contains";
      hide_scroll = true;
      show_all = false;
    };

    style = ''
      window {
        margin: 0px;
        border: 1px solid #3d3d3d;
        background-color: transparent;
        border-radius: 12px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
        font-family: "Cantarell", sans-serif;
        font-size: 14px;
      }

      #input {
        margin: 12px;
        padding: 12px 16px;
        border: 1px solid #3d3d3d;
        background-color: rgba(56, 56, 56, 0.9);
        border-radius: 8px;
        color: #ffffff;
        font-size: 14px;
        box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2);
      }

      #input:focus {
        border-color: #3584e4;
        box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.2), 0 0 0 2px rgba(53, 132, 228, 0.4);
        outline: none;
      }

      #inner-box {
        margin: 0px 12px 12px 12px;
        border: none;
        background-color: transparent;
        border-radius: 0px;
      }

      #outer-box {
        margin: 0px;
        border: none;
        background-color: rgba(36, 36, 36, 0.9);
        border-radius: 12px;
      }

      #scroll {
        margin: 0px;
        border: none;
        border-radius: 8px;
      }

      #text {
        margin: 5px;
        border: none;
        color: #ffffff;
        font-weight: normal;
      }

      #entry {
        padding: 8px 12px;
        margin: 2px 0px;
        border: none;
        border-radius: 6px;
        background-color: transparent;
        transition: all 0.2s ease;
      }

      #entry:selected {
        background-color: #3584e4;
        color: #ffffff;
        border-radius: 6px;
      }

      #entry:selected #text {
        color: #ffffff;
        font-weight: normal;
      }

      #entry:hover {
        background-color: rgba(53, 132, 228, 0.15);
        color: #ffffff;
        border-radius: 6px;
      }

      #entry:hover #text {
        color: #ffffff;
      }

      #entry img {
        margin-right: 12px;
        border-radius: 4px;
      }
    '';
  };

  home.packages = with pkgs; [
    (writeShellScriptBin "power-menu" ''
      #!${pkgs.bash}/bin/bash

      choice=$(echo -e "Logout\nReboot\nShutdown" | wofi --dmenu --prompt "Power Menu")

      case $choice in
        "Logout")
          hyprctl dispatch exit
          ;;
        "Reboot")
          systemctl reboot
          ;;
        "Shutdown")
          systemctl poweroff
          ;;
      esac
    '')
  ];
}
