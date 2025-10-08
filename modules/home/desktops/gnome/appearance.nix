{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  # Use alternative icons (no Finder icon)
  whitesurIconTheme = pkgs.whitesur-icon-theme.override {
    alternativeIcons = true;
  };
in
{
  home.file.".local/share/icons/Neuwaita".source = inputs.neuwaita;

  home.packages = with pkgs; [
    adw-gtk3
  ];

  home.pointerCursor = {
    name = "WhiteSur-cursors";
    package = pkgs.whitesur-cursors;
    size = 24; # Adjust size as needed
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    # iconTheme = {
    #   name = "WhiteSur-dark";
    #   package = whitesurIconTheme;
    # };

    iconTheme = {
      name = "Neuwaita";
    };
  };

  xdg.configFile."gtk-4.0/gtk.css".enable = lib.mkForce false;
}
