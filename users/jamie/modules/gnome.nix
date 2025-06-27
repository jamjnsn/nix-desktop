{ config, pkgs, gnomeExtensions, ... }:
let 
  whitesurIconTheme = pkgs.whitesur-icon-theme.override {
    alternativeIcons = true;
  };
in
{
  home.packages = 
    (with pkgs; [
    ]) ++ gnomeExtensions;

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "WhiteSur-dark";
      package = whitesurIconTheme;
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
