# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ "${debian_chroot:-}" = "" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# eza aliases (modern ls replacement)
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first --header'
alias la='eza -a --icons --group-directories-first'
alias l='eza --icons --group-directories-first'
alias lt='eza -la --icons --tree --level=2 --group-directories-first'
alias c='clear'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export PATH="$HOME/.local/bin:$PATH"
. "$HOME/.cargo/env"
eval "$(rustup completions bash)"
eval "$(rustup completions bash cargo)"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
eval "$(mise activate bash)"
eval "$(mise completion bash --include-bash-completion-lib)"

# FZF config
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# FZF commands (use fd for speed)
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# FZF preview options
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --group-directories-first {}'"

eval "$(fzf --bash)"

# fzf-tab-completion - replace TAB with fzf
source ~/.config/fzf-tab-completion/bash/fzf-bash-completion.sh

# fzf-git.sh - git integration for fzf
[ -f ~/fzf-git.sh/fzf-git.sh ] && source ~/fzf-git.sh/fzf-git.sh

eval "$(starship init bash)"
eval "$(zoxide init bash)"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
eval "$(pnpm completion bash)"
# pnpm end

# tmux completion
source ~/.config/bash-completion/tmux.bash

# Editor
export EDITOR="nvim"

# Vi mode
set -o vi

# fzf-tab-completion bind (must be after vi mode)
bind -x '"\t": fzf_bash_completion'

# Ctrl+P/N history search
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# LazyGit config
export CONFIG_DIR="$HOME/.config/lazygit"

# yazi integration - cd to directory on exit
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ "$cwd" != "" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
