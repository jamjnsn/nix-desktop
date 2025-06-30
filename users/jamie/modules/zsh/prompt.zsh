# ==================================================
# Get information
# ==================================================

# Find out if connection is SSH
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    local is_ssh=true
else
    local is_ssh=false
fi

# Get OS name
if [ -f /etc/os-release ]; then
    . /etc/os-release
    local os=$NAME
else
	local os=Unknown
fi

# Get hostname
local host=$(uname -n)

# Define special characters
local line_up=$'\e[1A'
local line_down=$'\e[1B'
local newline=$'\n'

# ==================================================
# Prompt settings
# ==================================================

local current_dir=$'%~'

if [[ "$is_ssh" = "true" ]]; then
    local prompt_symbol=''

    if [[ $UID -eq 0 ]]; then
        local user_info=$'%F{yellow}%n%F{red}@%F{yellow}%m'
        local user_prompt="${user_info} %F{red}${prompt_symbol}%F{yellow}${prompt_symbol}%F{red}${prompt_symbol}"
    else
        local user_info=$'%F{magenta}%n%F{cyan}@%F{green}%m'
        local user_prompt="%F{cyan}${user_info} %F{magenta}${prompt_symbol}%F{cyan}${prompt_symbol}%F{green}${prompt_symbol}"
    fi
else
    local prompt_symbol=''

    if [[ $UID -eq 0 ]]; then
        local user_prompt="%F{red}${prompt_symbol}"
    else
        local user_prompt="%F{grey}${prompt_symbol}"
    fi
fi

# ==================================================
# Pre-command prompt
# ==================================================

local prompt_precmd() {
    # Add newline
    print -P ''
}

# ==================================================
# Print Git status
# ==================================================

local get_git_status () {
    # Check if current directory is a Git repo
    if $(git rev-parse --is-inside-work-tree 2>/dev/null); then
        local git_prompt="in repo"
        echo " $(git branch --show-current)"
    fi
}

# ==================================================
# Print return code if not 0
# ==================================================

local get_return_status () {
    echo $'%(?..%{%F{red}%}↵ %?%f%b)'
}

# ==================================================
# Set prompt variables
# ==================================================

local set_prompt () {
    add-zsh-hook precmd prompt_precmd   # Set pre-command prompt
    setopt prompt_subst                 # Enable expansion in prompt string

    RPROMPT=""
    PROMPT=$'%F{240}%~ %f$(get_git_status)'" %K{clear} %f${newline}$reset_color${user_prompt}%f $reset_color"
}

set_prompt