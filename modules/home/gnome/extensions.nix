{ pkgs, ... }:
let
  extensions = with pkgs.gnomeExtensions; [
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
    tiling-shell
  ];
in
{
  home.packages = extensions;

  dconf.settings = {
    "org/gnome/shell".disable-user-extensions = false;
    "org/gnome/shell".enabled-extensions = map (extension: extension.extensionUuid) extensions;

    "org/gnome/shell/extensions/just-perfection" = {
      animation = 5;
      workspace-wrap-around = true;
      startup-status = 0; # 0 - Desktop, 1 - Overview
      window-demands-attention-focus = true; # Switch to window instead of displaying "window is ready"
    };

    "org/gnome/shell/extensions/tilingshell" = {
      enable-blur-selected-tilepreview = true;
      enable-blur-snap-assistant = true;
      enable-move-keybindings = false;
      inner-gaps = 0;
      outer-gaps = 0;
      overridden-settings = ''{"org.gnome.mutter":{"edge-tiling":"true"}}'';
      show-indicator = true;
    };

    "org/gnome/shell/extensions/caffeine" = {
      show-notifications = false;
    };
  };
}
