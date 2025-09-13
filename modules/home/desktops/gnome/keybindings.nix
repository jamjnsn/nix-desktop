{ pkgs, ... }:
{
  dconf.settings = {
    # Bind caps lock to hyper
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:hyper" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        # "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
      ];
    };

    # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    #   name = "Terminal Dropdown";
    #   command = "kitty-tdrop";
    #   binding = "<Super>grave";
    # };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Emoji Picker";
      command = "flatpak run it.mijorus.smile";
      binding = "<Super>period";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Resource Monitor";
      command = "${pkgs.resources}/bin/resources";
      binding = "<Control><Shift>Escape";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "Terminal";
      command = "${pkgs.ghostty}/bin/ghostty";
      binding = "<Hyper>t";
    };
  };
}
