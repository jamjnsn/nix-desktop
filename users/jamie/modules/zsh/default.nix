{ lib, ... }:
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
      rm = "gomi";

      # Colorize
      ping = "grc \\ping";

      # Add untracked files in the repo and rebuild the system flake
      nrs = "(cd ~/.config/nixos && git add -N . && sudo nixos-rebuild switch --flake .)";

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

    # Extra config in .zsh files for syntax highlighting
    initContent = lib.concatStringsSep "\n" [
      (builtins.readFile ./options.zsh)
      (builtins.readFile ./functions.zsh)
      (builtins.readFile ./prompt.zsh)
    ];
  };
}
