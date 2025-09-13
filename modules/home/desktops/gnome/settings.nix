{ config, ... }:
{

  dconf = {
    enable = true;

    settings = {
      "org/gnome/system/location" = {
        enabled = true;
      };

      # Disable notifications on the lockscreen
      "org/gnome/desktop/notifications" = {
        show-in-lock-screen = false;
      };

      # Appearance
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        show-battery-percentage = "true";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-schedule-automatic = true;
      };
    };
  };
}
