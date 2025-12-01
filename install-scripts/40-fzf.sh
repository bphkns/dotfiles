#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 40: FZF"

if [ ! -d "$HOME/.fzf" ]; then
    log_info "Cloning FZF..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-bash --no-fish
else
    log_success "FZF already installed."
fi
