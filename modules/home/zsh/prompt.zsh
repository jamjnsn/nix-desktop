# ==================================================
# Add ZSH color support
# ==================================================

# ==================================================
# Add ZSH color support
# ==================================================

# Enable required zsh features
setopt prompt_subst
autoload -U add-zsh-hook colors && colors

# ==================================================
# Gather system information
# ==================================================

_prompt_cache_system_info() {
    # Detect SSH connection
    if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; then
        _PROMPT_IS_SSH=true
    else
        _PROMPT_IS_SSH=false
    fi

    # Cache hostname
    _PROMPT_HOST="$(hostname -s)"
}

_prompt_cache_system_info

# ==================================================
# Git
# ==================================================

_prompt_git_info() {
    # Exit if not in git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch_name
    local git_status=""
    local git_color="green"

    # Get current branch or commit hash
    branch_name="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"

    # Check for uncommitted changes
    if ! git diff --quiet 2>/dev/null; then
        git_color="yellow"
        git_status="*"
    fi

    # Check for untracked files
    if [[ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]]; then
        git_status="${git_status}+"
    fi

    # Check for staged changes
    if ! git diff --cached --quiet 2>/dev/null; then
        git_status="${git_status}●"
    fi

    # Output git info
    _draw_bubble yellow " ${branch_name}${git_status}%f"
}

# ==================================================
# Return Status
# ==================================================

_prompt_return_status() {
    echo '%(?..%F{red} %?%f )'
}

# ==================================================
# User and Host Information
# ==================================================

_prompt_user_host() {
    local user_color host_color prompt_char

    if [[ $EUID -eq 0 ]]; then
        prompt_char="%F{red}%f"
    else
        prompt_char="%F{white}%f"
    fi

    if [[ "$_PROMPT_IS_SSH" == "true" ]]; then
        echo "%f%n@%m ${prompt_char}"
    else
        echo "${prompt_char}"
    fi
}

# ==================================================
# Directory Information
# ==================================================

_prompt_directory() {
    local dir_color="%F{240}"
    local current_dir="%~"

    # Color directory differently if not writable
    if [[ ! -w "$PWD" ]]; then
        dir_color="%F{red}"
    fi

    echo "${dir_color}${current_dir}%f"
}

# ==================================================
# nix-shell info
# ==================================================

_prompt_nix_shell() {
    if [[ -n "$IN_NIX_SHELL" ]]; then
        _draw_bubble blue "󱄅"
    fi
}

# ==================================================
# Virtual Environment Info
# ==================================================

_prompt_venv() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        _draw_bubble green " $(basename $VIRTUAL_ENV)"
    fi
}

# ==================================================
# Prompt Assembly
# ==================================================

_draw_bubble() {
    local color=$1
    local text=$2

    echo "%F{$color}%f%K{$color}%F{black}$text%F{$color}%k%f"
}

_prompt_precmd() {
    # Add spacing before prompt
    echo
}

_prompt_build() {
    local left_prompt=""
    left_prompt+='$(_prompt_directory)'
    left_prompt+=' $(_prompt_git_info)'
    left_prompt+='$(_prompt_venv)'
    left_prompt+=$'\n'
    left_prompt+='$(_prompt_nix_shell)'
    left_prompt+='$(_prompt_user_host) '

    local right_prompt='$(_prompt_return_status)'

    PROMPT="$left_prompt"
    RPROMPT="$right_prompt"
}

# ==================================================
# Initialization
# ==================================================

# Set up hooks
add-zsh-hook precmd _prompt_precmd

# Build and activate prompt
_prompt_build
