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

# Completion paths
_zsh_cache_dir="$HOME/.cache/zsh"
[[ -d "$_zsh_cache_dir" ]] || mkdir -p "$_zsh_cache_dir"
fpath=(~/.local/share/zsh/completions "$_zsh_cache_dir" $fpath)

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && fpath=("$HOME/.bun" $fpath)

# Generated Zsh completions must exist before compinit scans fpath.
_mise_comp="$_zsh_cache_dir/_mise"
_mise_bin="$(command -v mise)"
if [[ -n "$_mise_bin" && (! -f "$_mise_comp" || "$_mise_bin" -nt "$_mise_comp") ]]; then
    mise completion zsh > "$_mise_comp"
fi

_cloud_sql_proxy_comp="$_zsh_cache_dir/_cloud-sql-proxy"
_cloud_sql_proxy_bin="$(command -v cloud-sql-proxy)"
if [[ -n "$_cloud_sql_proxy_bin" && (! -f "$_cloud_sql_proxy_comp" || "$_cloud_sql_proxy_bin" -nt "$_cloud_sql_proxy_comp") ]]; then
    cloud-sql-proxy completion zsh > "$_cloud_sql_proxy_comp"
fi

# Completion system (must run before fzf-tab)
autoload -Uz compinit
compinit

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" && -n "${commands[git]}" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" >/dev/null 2>&1 || true
fi

if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
    source "${ZINIT_HOME}/zinit.zsh"
    zinit cdreplay -q

    # fzf-tab (must load after compinit, before other widgets)
    zinit light Aloxaf/fzf-tab

    # fzf-git.sh - git helpers with fzf (Ctrl-G Ctrl-F/B/T/R/H/S/E)
    _fzf_git_sh="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/plugins/junegunn---fzf-git.sh/fzf-git.sh"
    [[ -f "$_fzf_git_sh" ]] && source "$_fzf_git_sh"
    unset _fzf_git_sh

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

    # Node version helper
    zinit ice wait"1" lucid
    zinit light lukechilds/zsh-nvm 2>/dev/null || true
fi

# Google Cloud SDK (direct source - faster than OMZP::gcloud)
for _gcloud_sdk_dir in "$HOME/google-cloud-sdk" /opt/google-cloud-cli; do
    if [[ -d "$_gcloud_sdk_dir" ]]; then
        [[ -f "$_gcloud_sdk_dir/path.zsh.inc" ]] && source "$_gcloud_sdk_dir/path.zsh.inc"
        [[ -f "$_gcloud_sdk_dir/completion.zsh.inc" ]] && source "$_gcloud_sdk_dir/completion.zsh.inc"
        break
    fi
done
unset _gcloud_sdk_dir

# Zoxide (cached)
_zoxide_cache="$_zsh_cache_dir/zoxide.zsh"
_zoxide_bin="$(command -v zoxide)"
if [[ -n "$_zoxide_bin" && (! -f "$_zoxide_cache" || "$_zoxide_bin" -nt "$_zoxide_cache") ]]; then
    zoxide init zsh > "$_zoxide_cache"
fi
[[ -f "$_zoxide_cache" ]] && source "$_zoxide_cache" && alias zz='__zoxide_zi'

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

# FZF config
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --group-directories-first {}'"
export FZF_COMPLETION_OPTS="--bind 'tab:down,shift-tab:up'"

[[ -f "$HOME/.acme.sh/acme.sh.env" ]] && . "$HOME/.acme.sh/acme.sh.env"

# Added by git-ai installer on Tue Jan 27 12:08:23 PM IST 2026
[[ -d "$HOME/.git-ai/bin" ]] && export PATH="$HOME/.git-ai/bin:$PATH"

# Vite+ bin (https://viteplus.dev)
[[ -f "$HOME/.vite-plus/env" ]] && . "$HOME/.vite-plus/env"

# Mise (cached activation + completions)
_mise_cache_dir="$_zsh_cache_dir"
_mise_activate="$_mise_cache_dir/mise-activate.zsh"
_mise_bin="$(command -v mise)"
if [[ -n "$_mise_bin" && (! -f "$_mise_activate" || "$_mise_bin" -nt "$_mise_activate") ]]; then
    mkdir -p "$_mise_cache_dir"
    mise activate zsh > "$_mise_activate"
fi
[[ -f "$_mise_activate" ]] && source "$_mise_activate"

# Starship prompt (cached)
_starship_cache="$_mise_cache_dir/starship.zsh"
_starship_bin="$(command -v starship)"
if [[ -n "$_starship_bin" && (! -f "$_starship_cache" || "$_starship_bin" -nt "$_starship_cache") ]]; then
    starship init zsh > "$_starship_cache"
fi
[[ -f "$_starship_cache" ]] && source "$_starship_cache"

# OpenCode currently emits Bash completions, so don't source them in Zsh.

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

# yazi integration - cd to directory on exit (q to cd, Q to stay)
function yy() {
    (( $+commands[yazi] )) || { print -u2 "yazi is not installed"; return 127; }
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
# CF CLI completions
[[ -f "$HOME/.config/cf/completions/_cf.zsh" ]] && source "$HOME/.config/cf/completions/_cf.zsh"

# add Pulumi to the PATH
[[ -d "$HOME/.pulumi/bin" ]] && export PATH="$PATH:$HOME/.pulumi/bin"
