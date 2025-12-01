#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 80: Tmux Plugin Manager"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log_info "Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    log_success "TPM already installed."
fi
