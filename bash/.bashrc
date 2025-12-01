# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=100000

# Shell options
shopt -s checkwinsize

# Lesspipe
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$HOME/.fzf/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Cargo
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# eza aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first --header'
alias la='eza -a --icons --group-directories-first'
alias l='eza --icons --group-directories-first'
alias lt='eza -la --icons --tree --level=2 --group-directories-first'
alias c='clear'

# FZF config
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --group-directories-first {}'"

# FZF keybindings (Ctrl-T, Ctrl-R, Alt-C)
eval "$(fzf --bash)"

# Mise (runtime manager)
eval "$(mise activate bash)"

# Starship prompt
eval "$(starship init bash)"

# Zoxide - smart directory jumping (z, zi)
eval "$(zoxide init bash)"

# Google Cloud SDK
if [[ -f "$HOME/google-cloud-sdk/path.bash.inc" ]]; then
    source "$HOME/google-cloud-sdk/path.bash.inc"
fi

# Editor
export EDITOR="nvim"

# Vi mode
set -o vi

# Ctrl+P/N history search
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'

# LazyGit config
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# yazi integration - cd to directory on exit (q to cd, Q to stay)
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
