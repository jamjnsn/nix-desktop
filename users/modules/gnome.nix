{ config, pkgs, ... }:
{
  home.packages = 
    (with pkgs; [
    ]) ++
    (with pkgs.gnomeExtensions; [
      # These also need to be added to dconf below. I couldn't find a way to keep this DRY.
      blur-my-shell 
      caffeine 
      gsconnect 
      removable-drive-menu 
      user-themes 
    ]);

    dconf.settings = {
    "org/gnome/shell".enabled-extensions =
      map (extension: extension.extensionUuid) (with pkgs.gnomeExtensions; [ 
          blur-my-shell 
          caffeine 
          gsconnect 
          removable-drive-menu 
          user-themes
        ]);
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
