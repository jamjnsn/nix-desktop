{ pkgs, lib, gnomeExtensions, ... }:
{
  dconf = {
    enable = true;

    settings = {
      "org/gnome/shell".favorite-apps = [
        "firefox.desktop"
        "com.spotify.Client.desktop"
        "com.discordapp.Discord.desktop"
        "md.obsidian.Obsidian.desktop"
        "kitty.desktop"
        "code.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      
      "org/gnome/system/location" = {
        enabled = true;
      };

      # Appearance
      "org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita-dark";
        color-scheme = "prefer-dark";
        show-battery-percentage = "true";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
      };

      # Keybindings
      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = [];
        switch-applications-backward = [];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Shift><Alt>Tab" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Kitty Tdrop";
        command = "/home/jamie/.local/bin/kitty-tdrop.sh";
        binding = "<Super>grave";
      };

      # Power settings
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 7200; # In seconds. This is 2 hours.
      };

      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 900;
      };

      # Extensions
      "org/gnome/shell".disable-user-extensions = false;
      "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) gnomeExtensions;
      "org/gnome/shell/extensions/just-perfection" = {
        animation = 4;
        workspace-wrap-around = true; 
      };
    };
  };
}
