# Shortcuts
alias root="sudo -i"
alias dc="docker compose"

# Default args
alias mv="mv -iv"
alias cp="cp -iv --reflink=auto" # Use reflink where supported
alias mkdir="mkdir -pv"
alias wget="wget -c"
alias du="du -h"
alias df="df -h"
alias diff="diff --color"

# Colorize
alias ping="grc \\ping"

# Nix shell with packages (arguments can be empty)
alias nsh="nix-shell --packages"

# For some reason `agenix-cli` doesn't work but this does:
alias agenix="nix run github:ryantm/agenix --"
