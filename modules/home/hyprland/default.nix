{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    playerctl
    hyprpaper
  ];

  services.hyprpaper.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      env = [
        "XCURSOR_SIZE,26"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      # Startup apps
      exec-once = [
        "waybar"
        "hyprpaper"
      ];

      input = {
        kb_layout = "us";
        follow_mouse = 0;

        touchpad = {
          natural_scroll = true;
          middle_button_emulation = false;
          clickfinger_behavior = false;
          tap-to-click = true;
          tap-and-drag = true;
          drag_lock = false;
        };

        sensitivity = 0;
      };

      # General settings
      general = {
        gaps_in = 3;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 5;

        blur = {
          enabled = true;
          size = 7;
          passes = 2;
        };

        inactive_opacity = 0.9;
        active_opacity = 1.0;
      };

      layerrule = [
        "blur, wofi"
        "ignorealpha 0.5, wofi"
        "blur, waybar"
        "ignorealpha 0.8, waybar"
      ];

      # Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 4, myBezier"
          "windowsOut, 1, 4, default, popin 80%" # Reduced from 7 to 4
          "border, 1, 6, default" # Reduced from 10 to 6
          "borderangle, 1, 5, default" # Reduced from 8 to 5
          "fade, 1, 4, default" # Reduced from 7 to 4
          "workspaces, 1, 3, default" # Reduced from 6 to 3
        ];
      };

      # Layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      windowrulev2 = [
        "opacity 0.8 0.8,class:^(wofi)$"
      ];

      # Variables
      "$mainMod" = "SUPER";

      # Key bindings
      bind = [
        ", mouse:274, exec," # Disable phsical middle-click

        # Applications
        "$mainMod, T, exec, ghostty"
        "$mainMod, E, exec, nautilus"
        "$mainMod, space, exec, wofi --show drun"

        "$mainMod SHIFT, L, exec, power-menu" # Launch wofi power-menu

        "$mainMod SHIFT, R, exec, hyprctl reload"

        # Move focus
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod SHIFT, Q, killactive"

        "$mainMod, W, exec, hypr-cycle-width"
        "ALT, TAB, focuscurrentorlast"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"

        # Move to workspace
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"

        # Media keys
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      
      preload = [
        "~/.config/wallpaper.png"
      ];
      
      wallpaper = [
        ",~/.config/wallpaper.png"
      ];
    };
  }
}
