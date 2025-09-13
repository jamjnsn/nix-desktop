{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnome-tweaks
    refine # Tweaks alternative
  ];

  dconf.settings = {
    # Favorites
    "org/gnome/shell".favorite-apps = [
      "app.zen_browser.zen.desktop"
      "com.spotify.Client.desktop"
      "com.discordapp.Discord.desktop"
      "md.obsidian.Obsidian.desktop"
      "com.mitchellh.ghostty.desktop"
      "code.desktop"
      "org.gnome.Nautilus.desktop"
    ];

    # Disable alert on first launch
    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    # Automatically connect to system qemu in virt-manager
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };

    # Text editor settings
    "org/gnome/TextEditor" = {
      highlight-current-line = true;
      show-line-numbers = true;
      restore-session = false;
    };
  };
}
