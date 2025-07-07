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
    ];

    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
  };

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
