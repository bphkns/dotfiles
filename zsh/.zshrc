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
    compinit -C  # Skip security check, use cache
fi
zinit cdreplay -q

# fzf-tab (must load after compinit, before other widgets)
zinit light Aloxaf/fzf-tab

# Other plugins with Turbo mode
zinit wait lucid light-mode for \
    junegunn/fzf-git.sh

# pnpm completion (needs build step)
zinit ice wait lucid atclone"./zplug.zsh" atpull"%atclone"
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

# Zoxide - smart directory jumping (z, zi)
eval "$(zoxide init zsh)"

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
export FZF_DEFAULT_OPTS="--highlight-line --info=inline-right --ansi --layout=reverse --border=none"
export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons --group-directories-first {}'"
export FZF_COMPLETION_OPTS="--bind 'tab:down,shift-tab:up'"

# Mise
eval "$(mise activate zsh)"

# Starship prompt
eval "$(starship init zsh)"

# Editor
export EDITOR="nvim"

# Vi mode
bindkey -v
KEYTIMEOUT=10  # 100ms - balance between ESC responsiveness and fzf-git.sh two-key bindings

# Ctrl+P/N history search (works in vi mode)
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

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
