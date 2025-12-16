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

# Rustup/Cargo completions (pre-generated)
fpath=(~/.local/share/zsh/completions $fpath)

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

# Zoxide - smart directory jumping (z, zz for interactive)
eval "$(zoxide init zsh)"
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
alias lt='eza -la --icons --tree --level=2 --group-directories-first'
alias c='clear'

# alert alias
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# FZF config
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none \
  --color=bg:#000000,fg:#F0EBE6,hl:#519BFF \
  --color=bg+:#1A1A1A,fg+:#FFDACC,hl+:#519BFF \
  --color=info:#546D79,prompt:#53D390,pointer:#FFA247 \
  --color=marker:#C28EFF,spinner:#5ABAAE,header:#546D79"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --group-directories-first {}'"
export FZF_COMPLETION_OPTS="--bind 'tab:down,shift-tab:up'"

# Mise (cached activation + completions)
_mise_cache_dir="$HOME/.cache/zsh"
_mise_activate="$_mise_cache_dir/mise-activate.zsh"
_mise_comp="$_mise_cache_dir/_mise"
_mise_bin="$(command -v mise)"
if [[ ! -f "$_mise_activate" || "$_mise_bin" -nt "$_mise_activate" ]]; then
    mkdir -p "$_mise_cache_dir"
    mise activate zsh > "$_mise_activate"
    mise completion zsh > "$_mise_comp"
fi
source "$_mise_activate"

# Starship prompt
eval "$(starship init zsh)"

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

printf "zsh startup: %.0fms\n" $(( (EPOCHREALTIME - _zsh_start_time) * 1000 ))
