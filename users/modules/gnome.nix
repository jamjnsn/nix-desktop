{ config, pkgs, ... }:
{
  home.packages = 
    (with pkgs; [
    ]) ++
    (with pkgs.gnomeExtensions; [
      # These also need to be added to dconf.nix to enable them.
      # I couldn't find a way to keep this DRY.
      blur-my-shell 
      caffeine 
      gsconnect 
      removable-drive-menu 
      user-themes 
    ]);

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "Adwaita-dark";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
}
