{ ... }:
let
  browser = "app.zen_browser.zen.desktop";
  audioPlayer = "org.gnome.Decibels.desktop";
  videoPlayer = "io.github.celluloid_player.Celluloid.desktop";
in
{

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;

      defaultApplications = {
        # Browser
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "application/pdf" = browser;
        "application/x-pdf" = browser;

        # Communication
        "x-scheme-handler/sms" = "org.gnome.Shell.Extensions.GSConnect.desktop";
        "x-scheme-handler/tel" = "org.gnome.Shell.Extensions.GSConnect.desktop";
        "x-scheme-handler/mailto" = browser;

        # Video
        "video/mp4" = videoPlayer;
        "video/x-matroska" = videoPlayer;
        "video/webm" = videoPlayer;
        "video/avi" = videoPlayer;
        "video/quicktime" = videoPlayer;
        "video/x-msvideo" = videoPlayer;
        "video/x-ms-wmv" = videoPlayer;
        "video/x-flv" = videoPlayer;

        # Audio
        "audio/mpeg" = audioPlayer;
        "audio/mp3" = audioPlayer;
        "audio/flac" = audioPlayer;
        "audio/ogg" = audioPlayer;
        "audio/wav" = audioPlayer;
        "audio/x-wav" = audioPlayer;
        "audio/aac" = audioPlayer;
        "audio/mp4" = audioPlayer;
        "audio/x-m4a" = audioPlayer;
      };
    };
  };
}
