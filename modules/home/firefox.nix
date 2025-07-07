{ pkgs, inputs, ... }:
let
  userId = builtins.toString (builtins.getEnv "UID");
in
{
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        bitwarden
      ];

      userChrome = ''
        @import url("firefox-gnome-theme/userChrome.css");
      '';

      userContent = ''
        @import url("firefox-gnome-theme/userContent.css");
      '';

      extraConfig = ''
        /* Enable user CSS */
        user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

        /* Allows SVGs to adapt to light/dark mode */
        user_pref("svg.context-properties.content.enabled", true);

        /* Browser cache */
        user_pref("browser.cache.disk.enable", false);
        user_pref("browser.cache.memory.enable", true);
        user_pref("browser.cache.disk.parent_directory", "/run/user/${userId}/firefox");

        /* Performance */
        user_pref("gfx.webrender.all", true);
        user_pref("layers.acceleration.force-enabled", true);
        user_pref("media.ffmpeg.vaapi.enabled", true);

        /* Privacy tweaks */
        user_pref("privacy.trackingprotection.enabled", true);
        user_pref("privacy.trackingprotection.socialtracking.enabled", true);
        user_pref("privacy.donottrackheader.enabled", true);
        user_pref("dom.webnotifications.enabled", false);
      '';
    };
  };

  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme" = {
    source = pkgs.fetchFromGitHub {
      owner = "rafaelmardojai";
      repo = "firefox-gnome-theme";

      # Rev and sha56 need to be updated together
      # `nix-prefetch-url --unpack https://github.com/rafaelmardojai/firefox-gnome-theme/archive/v137.tar.gz`
      rev = "v137";
      sha256 = "089cin1ilxb1gz34z8fhlaf8nlqgkpfq64jn66n2kvzafl6cn8d2";
    };

    recursive = true;
  };
}
