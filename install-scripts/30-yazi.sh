#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 30: Yazi File Manager"

# Ensure Cargo is available
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if ! command_exists yazi; then
    log_info "Installing yazi-build (compiling yazi-fm/cli)..."
    # --locked is recommended by yazi docs
    cargo install --locked yazi-build
else
    log_success "Yazi already installed."
fi
