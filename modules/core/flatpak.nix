{ inputs, pkgs, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    packages = [
      "com.discordapp.Discord"
      "com.spotify.Client"
      "md.obsidian.Obsidian"
      "org.gnome.World.PikaBackup"
      "com.github.tchx84.Flatseal"
      "it.mijorus.smile"
      "org.gnome.gitlab.YaLTeR.VideoTrimmer"
      "io.github.celluloid_player.Celluloid"
      "com.obsproject.Studio"
      "org.libreoffice.LibreOffice"
    ];

    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
  };
}
