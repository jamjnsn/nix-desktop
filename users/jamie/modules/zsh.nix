{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;

    autosuggestion = {
      enable = true;
    };

    sessionVariables = {

    };

    shellAliases = {
      # Shortcuts
      root = "sudo -i";
      ytdld = "yt-dlp -P ~/Downloads";

      # Default args
      mv = "mv -iv";
      cp = "cp -iv";
      mkdir = "mkdir -pv";
      wget = "wget -c";
      du = "du -h";
      df = "df -h";
      diff = "diff --color";

      # Replacements
      dig = "dog";
      cat = "bat";
      rm = "gomi";

      # Colorize
      ping = "grc \\ping";

      # Add untracked files in the repo and rebuild the system flake
      nrs = "(cd ~/.nixos && git add -N . && sudo nixos-rebuild switch --flake .)";

      # Nix shell with packages (arguments can be empty)
      nsh = "nix-shell --packages";

      # Update Nix packages
      update = "sudo nix-channel --update";
    };

    history.size = 10000;
    history.ignorePatterns = [
      "rm *"
      "pkill *"
      "cp *"
      "ls *"
      "cd *"
      "mv *"
      "pwd *"
      "exit *"
      "ls *"
    ];

    # Extra options (raw ZSH commands)
    initContent = ''
      # Imports
      source $HOME/.config/zsh/options.zsh
      source $HOME/.config/zsh/functions.zsh

      # Prompt
      source $HOME/.config/zsh/prompt.zsh
    '';
  };

  # Copy
  home.file.".config/zsh".source = ../dotfiles/zsh;
}
