#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 50: Neovim (via Bob)"

# Ensure Cargo is available
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if ! command_exists cargo; then
    log_error "Cargo not found. Skipping Bob/Neovim."
    exit 1
fi

if ! command_exists bob; then
    log_info "Installing Bob (Neovim Version Manager)..."
    cargo install bob-nvim
fi

export PATH="$HOME/.cargo/bin:$PATH"

if command_exists bob; then
    if ! command_exists nvim; then
        log_info "Installing Neovim stable..."
        bob install stable
        bob use stable
    else
        log_success "Neovim already installed."
    fi
else
    log_error "Bob installation failed."
    exit 1
fi
