{ lib, desktop, ... }:
{
  imports =
    lib.optionals desktop.gnome.enable [
      ./gnome
    ]
    ++ lib.optionals desktop.niri.enable [
      ./niri
    ];
}
