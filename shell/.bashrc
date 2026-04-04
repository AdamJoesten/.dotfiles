# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

######################################################################
# Custom additions below
######################################################################

[ -z "$PS1" ] && return

# XDG Base Directories (Strict Environment)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Path Management
if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) export PATH="$HOME/.local/bin:$PATH" ;;
    esac
fi

# Core Environment Variables
export EDITOR="nvim"
export VISUAL="nvim"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History Management (XDG Compliant)
export HISTFILE="$XDG_DATA_HOME/bash/history"
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
shopt -s checkwinsize

# Ensure history directory exists silently
mkdir -p "$(dirname "$HISTFILE")"

# Ubuntu Utilities (Kept for compatibility)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Core Aliases & Functions
alias ..="cd .."
alias ...="cd ../.."
alias vim="nvim"

if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons --group-directories-first"
    alias ll="eza -la --icons --group-directories-first"
    alias la="eza -a --icons --group-directories-first"
else
    alias ls="ls --color=auto"
    alias ll="ls -alF"
    alias la="ls -A"
fi

# Quick Capture Function
zcap() {
    echo "$*" >> "$HOME/Documents/Obsidian/Inbox/$(date +%Y%m%d%H%M%S)-capture.md"
}

# Source external aliases if they exist
if [ -f "$XDG_CONFIG_HOME/bash/aliases" ]; then
    source "$XDG_CONFIG_HOME/bash/aliases"
fi

# Modular Hooks (The Stow Drop-in Mechanism)
BASH_HOOKS_DIR="$XDG_CONFIG_HOME/bash/hooks"
if [ -d "$BASH_HOOKS_DIR" ]; then
    for hook in "$BASH_HOOKS_DIR"/*.sh; do
        [ -r "$hook" ] && source "$hook"
    done
fi

# Prompt Initialization
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
else
    PS1='\[\033[01;34m\]\w\[\033[00m\] \$ '
fi
