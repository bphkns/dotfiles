#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 10: Rust/Cargo Setup"

if ! command_exists cargo; then
    log_info "Installing Rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    log_success "Cargo already installed."
fi

# Ensure cargo is in path for subsequent scripts
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi
