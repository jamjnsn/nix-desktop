{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    extraConfig = ''
      set -g mouse on
      setw -g aggressive-resize on
      set-option -g allow-rename off

      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1

      # Set prefix to Ctrl+a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Pane controls
      bind q kill-pane
      bind ` last-pane
      bind z resize-pane -Z # zoom

      # Split panes using / and -
      bind / split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Switch panes using arrow keys (without prefix)
      bind -n Left select-pane -L
      bind -n Right select-pane -R
      bind -n Up select-pane -U
      bind -n Down select-pane -D

      # Resize panes using Shift+arrow keys (without prefix)
      bind -n S-Left resize-pane -L 3
      bind -n S-Right resize-pane -R 3
      bind -n S-Up resize-pane -U 3
      bind -n S-Down resize-pane -D 3

      # Window controls
      bind F2 command-prompt -I "#W" "rename-window '%%'"
      bind Tab last-window
      bind X confirm-before -p "kill-window #W? (y/n)" kill-window

      # Navigate windows with number keys
      bind 1 if-shell "tmux select-window -t 1" "" "new-window -t 1"
      bind 2 if-shell "tmux select-window -t 2" "" "new-window -t 2"
      bind 3 if-shell "tmux select-window -t 3" "" "new-window -t 3"
      bind 4 if-shell "tmux select-window -t 4" "" "new-window -t 4"
      bind 5 if-shell "tmux select-window -t 5" "" "new-window -t 5"
      bind 6 if-shell "tmux select-window -t 6" "" "new-window -t 6"
      bind 7 if-shell "tmux select-window -t 7" "" "new-window -t 7"
      bind 8 if-shell "tmux select-window -t 8" "" "new-window -t 8"
      bind 9 if-shell "tmux select-window -t 9" "" "new-window -t 9"
    '';
  };
}
