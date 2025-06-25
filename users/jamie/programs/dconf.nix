{ config, pkgs, gnomeExtensions, ... }:
{
  dconf = {
    enable = true;

    settings = {
      "org/gnome/shell".favorite-apps = [
        "firefox.desktop"
        "com.spotify.Client.desktop"
        "com.discordapp.Discord.desktop"
        "md.obsidian.Obsidian.desktop"
        "com.visualstudio.code.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
      ];

      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
        color-scheme = "prefer-dark";
        show-battery-percentage = "true";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
      };
      
      "org/gnome/system/location" = {
        enabled = true;
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = [];
        switch-applications-backward = [];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Shift><Alt>Tab" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>grave";
        command = "kitty-tdrop.sh";
        name = "Open Kitty tdrop";
      };

      # Extensions
      "org/gnome/shell".disable-user-extensions = false;
      "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) gnomeExtensions;
      "org/gnome/shell/extensions/just-perfection" = {
        animation = 2;
        workspace-wrap-around = true; 
      }
    };
  };
}
