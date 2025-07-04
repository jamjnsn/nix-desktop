{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Modify whitesur-icon-theme package options
  whitesurIconTheme = pkgs.whitesur-icon-theme.override {
    alternativeIcons = true;
  };

  # Define GNOME extensions
  gnomeExtensions = with pkgs.gnomeExtensions; [
    blur-my-shell
    caffeine
    gsconnect
    removable-drive-menu
    user-themes
    tailscale-qs
    appindicator # Tray icons
    just-perfection
    pip-on-top # Allows PiP from Firefox to work in Wayland
    wtmb-window-thumbnails # OnTopReplica
    dash-to-dock
    smile-complementary-extension # For automatic emoji pasting
  ];
in
{
  home.packages =
    (with pkgs; [
      gnome-tweaks
    ])
    ++ gnomeExtensions;

  home.pointerCursor = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    size = 24; # Adjust size as needed
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    iconTheme = {
      name = "WhiteSur-dark";
      package = whitesurIconTheme;
    };

    font = {
      name = "Cantarell";
      size = 11;
    };
  };

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

      # Disable notifications on the lockscreen
      "org/gnome/desktop/notifications" = {
        show-in-lock-screen = false;
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
        switch-applications = [ ];
        switch-applications-backward = [ ];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Shift><Alt>Tab" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Terminal Dropdown";
        command = "/home/jamie/.local/bin/kitty-tdrop";
        binding = "<Super>grave";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Emoji Picker";
        command = "{pkgs.smile}/bin/smile";
        binding = "<Super>period";
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
        animation = 5;
        workspace-wrap-around = true;
      };
    };
  };
}
