{
  programs.kitty = {
    enable = true;
    settings = {
      copy_on_select = "yes";
      strip_trailing_spaces = "always";
      enable_audio_bell = "no";

      enabled_layouts = "splits,stack";

      confirm_os_window_close = "0";
      show_hyperlink_targets = "yes";
      underline_hyperlinks = "always";

      font_family = "JetBrainsMono Nerd Font";
      font_size = "13.0";
      disable_ligatures = "never";
      font_features = "JetBrainsMonoNerdFont-Normal +zero +ss04 +ss03 +calt +ss01";

      cursor_shape = "underline";
      cursor_underline_thickness = "3.0";
      shell_integration = "no-cursor";
      cursor_trail = "1";

      linux_display_server = "x11"; # Needed for nice window decorations
      window_padding_width = "20";
      scrollback_fill_enlarged_window = "yes";
      window_border_width = "1pt";
      background_opacity = "0.98";
      dynamic_background_opacity = "yes";

      background = "#191919";
      foreground = "#bfbdb6";
      cursor = "#bfbdb6";
      selection_background = "#b2c8d6";
      selection_foreground = "#191919";
      color0 = "#292929";
      color8 = "#4a5054";
      color1 = "#ff355b";
      color9 = "#ff355b";
      color2 = "#b6e875";
      color10 = "#b6e875";
      color3 = "#ffc150";
      color11 = "#ffc150";
      color4 = "#75d3ff";
      color12 = "#75d4ff";
      color5 = "#b975e6";
      color13 = "#b975e6";
      color6 = "#6cbeb5";
      color14 = "#6cbeb5";
      color7 = "#c1c8d6";
      color15 = "#c1c8d6";
    };

    keybindings = {
      "ctrl+n" = "new_os_window";
      "ctrl+t" = "new_tab";
      "ctrl+tab" = "next_tab";
      "ctrl+shift+tab" = "previous_tab";
      "alt+enter" = "toggle_layout stack";
      "alt+/" = "launch --cwd=current --location=vsplit";
      "alt+-" = "launch --cwd=current --location=hsplit";
      "alt+q" = "close_window";
      "alt+left" = "neighboring_window left";
      "alt+right" = "neighboring_window right";
      "alt+up" = "neighboring_window up";
      "alt+down" = "neighboring_window down";
    };

    extraConfig = ''
      startup_session ~/.config/kitty/startup.conf
    '';
  };

  home.file.".config/kitty/startup.conf".text = ''
    new_tab Default
    layout tall
  '';
}
