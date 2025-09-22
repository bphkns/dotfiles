# Zinit (plugin manager)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Brew (macOS Homebrew setup)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Shell options
bindkey -v

# History config
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space
setopt hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups
fpath=(~/.config/zsh/completions $fpath)

# Load completions early with security check skip for speed
autoload -Uz compinit && compinit -C -d ~/.cache/zcompdump

# Zsh plugins (with lazy loading for performance)
zinit light zsh-users/zsh-completions
zinit light g-plane/pnpm-shell-completion

# Lazy load expensive plugins
zinit ice wait"1" lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait"1" lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait"1" lucid
zinit light Aloxaf/fzf-tab

# Oh-My-Zsh plugin snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::gcloud
zinit snippet OMZP::command-not-found

# Re-run compdefs if needed
zinit cdreplay -q

# Keybindings for history search (Ctrl+P/N)
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias cat='bat'
alias pyenv86="arch -x86_64 pyenv"

# Editor
export EDITOR="nvim"

# PNPM setup
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# RVM, Go, Java
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/usr/local/go/bin"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# PostgreSQL
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH=/home/bikash/.opencode/bin:$PATH
# Certificates
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"

# Starship prompt
eval "$(starship init zsh)"

# Zoxide (with correct completion setup)
eval "$(zoxide init --cmd cd zsh)"

# FZF config
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --ansi \
  --layout=reverse \
  --border=none \
  --color=bg+:#2d3f76 \
  --color=bg:#1e2030 \
  --color=border:#589ed7 \
  --color=fg:#c8d3f5 \
  --color=gutter:#1e2030 \
  --color=header:#ff966c \
  --color=hl+:#65bcff \
  --color=hl:#65bcff \
  --color=info:#545c7e \
  --color=marker:#ff007c \
  --color=pointer:#ff007c \
  --color=prompt:#65bcff \
  --color=query:#c8d3f5:regular \
  --color=scrollbar:#589ed7 \
  --color=separator:#ff966c \
  --color=spinner:#ff007c \
"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(fzf --zsh)"

# LazyGit config
export CONFIG_DIR="$HOME/.config/lazygit"

# zlib and OpenSSL
export LDFLAGS="-L/usr/local/opt/zlib/lib -L/usr/local/opt/openssl@3/lib"
export CPPFLAGS="-I/usr/local/opt/zlib/include -I/usr/local/opt/openssl@3/include"

# nvm (commented out - using fnm instead for better performance)
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# nx completion
source ~/.nx-completion/nx-completion.plugin.zsh

# yazi integration
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# ~/.zshrc file
function nx() {
    pnpm nx "$@"
}

# fnm setup (cached for performance)
FNM_PATH="$HOME/.local/share/fnm"

if [ -d "$FNM_PATH" ]; then
  # Cache fnm initialization for faster startup
  if [[ ! -f ~/.cache/fnm_init.zsh ]] || [[ ~/.zshrc -nt ~/.cache/fnm_init.zsh ]]; then
    mkdir -p ~/.cache
    fnm env --use-on-cd --shell zsh > ~/.cache/fnm_init.zsh
  fi
  source ~/.cache/fnm_init.zsh

  # Generate completions if missing
  if command -v fnm >/dev/null 2>&1; then
    COMPLETIONS_DIR="$HOME/.config/zsh/completions"
    COMPLETIONS_FILE="$COMPLETIONS_DIR/_fnm"

    if [ ! -f "$COMPLETIONS_FILE" ]; then
      mkdir -p "$COMPLETIONS_DIR"
      fnm completions --shell zsh > "$COMPLETIONS_FILE"
    fi
  fi
fi
