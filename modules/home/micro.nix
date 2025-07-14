{ ... }:
{
  programs.micro = {
    enable = true;

    settings = {
      colorscheme = "transparent";
      tabsize = 4;
      softwrap = true;
      ruler = true;
    };
  };

  # Shell alias so I don't forget to use micro
  programs.zsh.shellAliases = {
    nano = "micro";
  };

  xdg.configFile."micro/colorschemes/transparent.micro" = {
    text = ''
      color-link default "none,none"
      color-link comment "blue,none"
      color-link identifier "cyan,none"
      color-link constant "magenta,none"
      color-link statement "yellow,none"
      color-link type "green,none"
      color-link preproc "red,none"
      color-link special "brightmagenta,none"
      color-link underlined "underline,none"
      color-link error "brightred,none"
      color-link todo "brightblue,none"
      color-link selection "black,white"
      color-link statusline "white,black"
      color-link tabbar "white,black"
      color-link indent-char "brightblack,none"
      color-link line-number "brightblack,none"
      color-link current-line-number "white,none"
      color-link cursor-line "none,none"
      color-link color-column "none,none"
    '';
  };

  xdg.configFile."micro/bindings.json".text = ''
    {
      "Ctrl-Up": "CursorUp,CursorUp,CursorUp,CursorUp,CursorUp",
      "Ctrl-Down": "CursorDown,CursorDown,CursorDown,CursorDown,CursorDown",
      "Ctrl-Backspace": "DeleteWordLeft",
      "Ctrl-Delete": "DeleteWordRight",
      "CtrlShiftUp": "ScrollUp,ScrollUp,ScrollUp,ScrollUp,ScrollUp",
      "CtrlShiftDown": "ScrollDown,ScrollDown,ScrollDown,ScrollDown,ScrollDown"
    }
  '';
}
