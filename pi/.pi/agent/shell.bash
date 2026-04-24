shopt -s expand_aliases

alias c='clear'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -la --icons --git --group-directories-first --header'
  alias la='eza -a --icons --group-directories-first'
  alias l='eza --icons --group-directories-first'
fi
