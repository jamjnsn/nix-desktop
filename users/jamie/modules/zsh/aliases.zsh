# Shortcuts
alias root="sudo -i"
alias ytdld="yt-dlp -P ~/Downloads"

# Default args
alias mv="mv -iv"
alias cp="cp -iv"
alias mkdir="mkdir -pv"
alias wget="wget -c"
alias du="du -h"
alias df="df -h"
alias diff="diff --color"

# Replacements
alias rm="gomi_verbose"

# Colorize
alias ping="grc \\ping"

# Add untracked files in the repo and rebuild the system flake
alias nrs="(cd ~/.config/nixos && git add -N . && sudo nixos-rebuild switch --flake .)"

# Nix shell with packages (arguments can be empty)
alias nsh="nix-shell --packages"

# Update Nix packages
alias update="sudo nix-channel --update"
