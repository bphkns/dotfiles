#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 90: Lazygit"

if ! command_exists lazygit; then
    log_info "Installing Lazygit..."
    if command_exists go; then
        go install github.com/jesseduffield/lazygit@latest
    else
        # Binary install for Linux x86_64
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        if [ -n "$LAZYGIT_VERSION" ]; then
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            install lazygit "$HOME/.local/bin"
            rm lazygit lazygit.tar.gz
        else
            log_error "Failed to determine latest Lazygit version."
            exit 1
        fi
    fi
else
    log_success "Lazygit already installed."
fi
