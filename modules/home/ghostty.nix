{ ... }:
let
  splitResizeAmount = "20";
in
{
  programs.zsh.shellAliases = {
    ssh = "TERM=xterm-256color ssh";
  };

  programs.ghostty = {
    enable = true;
    settings = {
      shell-integration = "zsh";
      copy-on-select = "clipboard";
      app-notifications = "no-clipboard-copy";
      initial-command = "";

      # Font
      font-size = "13";
      cursor-style = "block";
      font-feature = [
        "+liga" # Enable ligatures
        "+clig"
        "+calt" # Contextual alternates (ligatures)
        "+ss01" # Stylistic Set 1
        "+ss03" # Stylistic Set 3
        "+ss04" # Stylistic Set 4
        "+zero" # Slashed zero
      ];

      # Window
      background-opacity = 0.98;
      background-blur = true;
      window-padding-x = 25;
      window-padding-y = 25;

      # Colors
      background = "191919";
      foreground = "bfbdb6";
      cursor-color = "bfbdb6";

      palette = [
        "0=292929" # black
        "1=ff355b" # red
        "2=b6e875" # green
        "3=ffc150" # yellow
        "4=75d3ff" # blue
        "5=b975e6" # magenta
        "6=6cbeb5" # cyan
        "7=c1c8d6" # white
        "8=4a5054" # bright black
        "9=ff355b" # bright red
        "10=b6e875" # bright green
        "11=ffc150" # bright yellow
        "12=75d4ff" # bright blue
        "13=b975e6" # bright magenta
        "14=6cbeb5" # bright cyan
        "15=c1c8d6" # bright white
      ];

      keybind = [
        "alt+z=toggle_split_zoom"

        # Split navigation with Alt + arrow keys
        "alt+left=goto_split:left"
        "alt+right=goto_split:right"
        "alt+up=goto_split:up"
        "alt+down=goto_split:down"

        # Split creation
        "alt+slash=new_split:right"
        "alt+minus=new_split:down"
        "alt+q=close_surface"

        # Split resizing
        "alt+shift+left=resize_split:left,${splitResizeAmount}"
        "alt+shift+right=resize_split:right,${splitResizeAmount}"
        "alt+shift+up=resize_split:up,${splitResizeAmount}"
        "alt+shift+down=resize_split:down,${splitResizeAmount}"
        "alt+equal=equalize_splits"

        # Tab navigation
        "alt+1=goto_tab:1"
        "alt+2=goto_tab:2"
        "alt+3=goto_tab:3"
        "alt+4=goto_tab:4"
        "alt+5=goto_tab:5"
        "alt+6=goto_tab:6"
        "alt+7=goto_tab:7"
        "alt+8=goto_tab:8"
        "alt+9=goto_tab:9"
      ];
    };
  };
}
