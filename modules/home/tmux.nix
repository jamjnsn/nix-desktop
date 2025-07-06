{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    aggressiveResize = true;
    historyLimit = 50000;
    keyMode = "vi";
    terminal = "tmux-256color";
    mouse = true;

    extraConfig = ''
      # set-environment -g TMUX_PLUGIN_MANAGER_PATH '~/.local/share/tmux/plugins'

      # Colors
      termbg="#121212"

      # Settings
      #set -g default-command
      set-option -g allow-rename on
      set -g window-size largest

      # Controls
      unbind '"'
      unbind %

      # Navigation
      bind Up select-pane -U
      bind Right select-pane -R
      bind Down select-pane -D
      bind Left select-pane -L

      # Resizing
      bind C-Up resize-pane -U 2
      bind C-Right resize-pane -R 2
      bind C-Down resize-pane -D 2
      bind C-Left resize-pane -L 2

      # Pane controls
      bind -n M-/ split-window -h
      bind -n M-- split-window -v
      bind -n M-q kill-pane

      # Zoom pane
      bind -n M-z resize-pane -Z

      # Quick reload tmux conf
      bind -n M-r source-file ~/.config/tmux/tmux.conf

      # Prefix-less controls
      bind -n M-Up select-pane -U
      bind -n M-Right select-pane -R
      bind -n M-Down select-pane -D
      bind -n M-Left select-pane -L

      bind -n C-Up resize-pane -U 2
      bind -n C-Right resize-pane -R 2
      bind -n C-Down resize-pane -D 2
      bind -n C-Left resize-pane -L 2

      bind -n M-] swap-pane -U
      bind -n M-[ swap-pane -D

      # Window selection
      bind-key -T root F1 if-shell 'tmux select-window -t :1' ''' 'new-window -t :1'
      bind-key -T root F2 if-shell 'tmux select-window -t :2' ''' 'new-window -t :2'
      bind-key -T root F3 if-shell 'tmux select-window -t :3' ''' 'new-window -t :3'
      bind-key -T root F4 if-shell 'tmux select-window -t :4' ''' 'new-window -t :4'
      bind-key -T root F5 if-shell 'tmux select-window -t :5' ''' 'new-window -t :5'
      bind-key -T root F6 if-shell 'tmux select-window -t :6' ''' 'new-window -t :6'
      bind-key -T root F7 if-shell 'tmux select-window -t :7' ''' 'new-window -t :7'
      bind-key -T root F8 if-shell 'tmux select-window -t :8' ''' 'new-window -t :8'
      bind-key -T root F9 if-shell 'tmux select-window -t :9' ''' 'new-window -t :9'
      bind-key -T root F10 if-shell 'tmux select-window -t :10' ''' 'new-window -t :10'
      bind-key -T root F11 if-shell 'tmux select-window -t :11' ''' 'new-window -t :11'
      bind-key -T root F12 if-shell 'tmux select-window -t :12' ''' 'new-window -t :12'

      # Theme
      set -g window-style 'fg=default,bg=default'
      set -g window-active-style 'fg=default,bg=default'

      set-option -g pane-border-style "fg=black"
      set-option -g pane-active-border-style "bg=default,fg=brightBlack"

      set -g message-style fg="cyan",bg="black",align="centre"
      set -g message-command-style fg="cyan",bg="black",align="centre"

      set-option -g status-style bg=default
      set -g status-position top
      set -g status "on"
      set -g status-justify "left"
      set -g status-left-length "100"
      set -g status-right-length "100"

      set -g status-left ""
      set -g status-right "#[fg=cyan]#[bg=cyan,fg=black]  #S#[fg=cyan,bg=default]"

      setw -g window-status-format "#[fg=brightBlack]#[fg=darkGrey,bg=brightBlack]#I #[fg=brightBlack,bg=darkGrey] #W #[fg=darkGrey,bg=default]"
      setw -g window-status-current-format "#[fg=brightBlack]#[fg=white,bg=brightBlack]#I #[fg=black,bg=white] #W #[fg=white,bg=default]"
    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-boot 'on'
          set -g @continuum-restore 'on'
        '';
      }
    ];
  };
}
