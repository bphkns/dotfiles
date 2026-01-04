zmodload zsh/datetime
_zsh_start_time=$EPOCHREALTIME

# History - larger sizes for better searchability
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY       # Save timestamps
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first when trimming
setopt HIST_IGNORE_DUPS       # Ignore consecutive duplicates
setopt HIST_IGNORE_SPACE      # Ignore commands starting with space
setopt HIST_SAVE_NO_DUPS      # Don't save duplicates to file
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching
setopt SHARE_HISTORY          # Share history between sessions (includes INC_APPEND_HISTORY)

# PATH (before plugins)
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

# Pre-generated completions (rustup, cargo, fd, rg, gh, starship, docker, bob, delta, bat, yazi, ghostty)
fpath=(~/.local/share/zsh/completions $fpath)

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && fpath=("$HOME/.bun" $fpath)

# Mise completions (cached)
fpath=(~/.cache/zsh $fpath)

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d $ZINIT_HOME ]] && mkdir -p "$(dirname $ZINIT_HOME)"
[[ ! -d $ZINIT_HOME/.git ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Completion system (must run before fzf-tab)
# Cache compinit - only rebuild once per day
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi
zinit cdreplay -q

# fzf-tab (must load after compinit, before other widgets)
zinit light Aloxaf/fzf-tab

# fzf-git.sh - git helpers with fzf (Ctrl-G Ctrl-F/B/T/R/H/S/E)
source "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/plugins/junegunn---fzf-git.sh/fzf-git.sh"

# pnpm completion (needs build step)
zinit ice wait"0" lucid atload"zpcdreplay" atclone"./zplug.zsh" atpull"%atclone"
zinit light g-plane/pnpm-shell-completion

# Syntax highlighting and autosuggestions (must load AFTER fzf-tab)
zinit wait lucid for \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting

# FZF shell integration (only keybindings - fzf-tab handles completion)
zinit ice wait lucid has"fzf" src"shell/key-bindings.zsh"
zinit light junegunn/fzf

# Google Cloud SDK (direct source - faster than OMZP::gcloud)
if [[ -d "$HOME/google-cloud-sdk" ]]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# npm completion (deferred)
zinit ice wait"1" lucid
zinit light lukechilds/zsh-nvm 2>/dev/null || {
    (( $+commands[npm] )) && zinit ice wait"1" lucid atload'eval "$(npm completion)"'; zinit light zdharma-continuum/null
}

# Zoxide (cached)
_zsh_cache_dir="$HOME/.cache/zsh"
[[ -d "$_zsh_cache_dir" ]] || mkdir -p "$_zsh_cache_dir"
_zoxide_cache="$_zsh_cache_dir/zoxide.zsh"
_zoxide_bin="$(command -v zoxide)"
if [[ ! -f "$_zoxide_cache" || "$_zoxide_bin" -nt "$_zoxide_cache" ]]; then
    zoxide init zsh > "$_zoxide_cache"
fi
source "$_zoxide_cache"
alias zz='__zoxide_zi'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# eza aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first --header'
alias la='eza -a --icons --group-directories-first'
alias l='eza --icons --group-directories-first'
# lt [level] - tree view, defaults to 1
unalias lt 2>/dev/null
lt() { eza -la --icons --tree --level=${1:-1} --group-directories-first "${@:2}"; }
alias lt2='lt 2'
alias lt3='lt 3'
alias lt4='lt 4'
alias c='clear'

# alert alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# FZF config - Vesper
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none \
  --color=bg:#101010,fg:#FFFFFF,hl:#99FFE4 \
  --color=bg+:#1A1A1A,fg+:#FFFFFF,hl+:#99FFE4 \
  --color=info:#ADD1DE,prompt:#FFC799,pointer:#D9B3FF \
  --color=marker:#99FFE4,spinner:#99FFE4,header:#ADD1DE"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --group-directories-first {}'"
export FZF_COMPLETION_OPTS="--bind 'tab:down,shift-tab:up'"

# Mise (cached activation + completions)
_mise_cache_dir="$_zsh_cache_dir"
_mise_activate="$_mise_cache_dir/mise-activate.zsh"
_mise_comp="$_mise_cache_dir/_mise"
_mise_bin="$(command -v mise)"
if [[ ! -f "$_mise_activate" || "$_mise_bin" -nt "$_mise_activate" ]]; then
    mkdir -p "$_mise_cache_dir"
    mise activate zsh > "$_mise_activate"
    mise completion zsh > "$_mise_comp"
fi
source "$_mise_activate"

# Starship prompt (cached)
_starship_cache="$_mise_cache_dir/starship.zsh"
_starship_bin="$(command -v starship)"
if [[ ! -f "$_starship_cache" || "$_starship_bin" -nt "$_starship_cache" ]]; then
    starship init zsh > "$_starship_cache"
fi
source "$_starship_cache"

# Opencode completion (cached)
_opencode_comp="$_mise_cache_dir/_opencode"
_opencode_bin="$(command -v opencode)"
if [[ -n "$_opencode_bin" && (! -f "$_opencode_comp" || "$_opencode_bin" -nt "$_opencode_comp") ]]; then
    opencode completion > "$_opencode_comp"
fi
[[ -f "$_opencode_comp" ]] && source "$_opencode_comp"

# Editor
export EDITOR="nvim"

# Vi mode
bindkey -v
KEYTIMEOUT=10  # 100ms - balance between ESC responsiveness and fzf-git.sh two-key bindings
bindkey -r "^G"  # Unbind list-expand to allow fzf-git.sh prefix

# Ctrl+P/N history search (works in vi mode)
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

# LazyGit config
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# lgaicm - AI commit message generation (3 tiers)
export LGAICM_SMALL_MODEL="sonnet"                          # < 4k chars
export LGAICM_MEDIUM_MODEL="google/gemini-2.5-flash-lite"   # < 50k chars
export LGAICM_LARGE_MODEL="google/gemini-2.5-flash"         # >= 50k chars (truncate at 200k)

# yazi integration - cd to directory on exit (q to cd, Q to stay)
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

# Startup time with nerd icon and color
_zsh_startup_ms=$(( (EPOCHREALTIME - _zsh_start_time) * 1000 ))
if (( _zsh_startup_ms < 100 )); then
    printf '\033[38;2;83;211;144m󱐋 %.0fms\033[0m\n' $_zsh_startup_ms  # Green - blazing fast
elif (( _zsh_startup_ms < 200 )); then
    printf '\033[38;2;255;218;204m %.0fms\033[0m\n' $_zsh_startup_ms  # Cream - good
else
    printf '\033[38;2;255;162;71m󰔛 %.0fms\033[0m\n' $_zsh_startup_ms   # Orange - slow
fi
unset _zsh_startup_ms _zsh_start_time
