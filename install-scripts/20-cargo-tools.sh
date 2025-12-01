#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 20: Core Cargo Tools"

# Ensure Cargo is available
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if ! command_exists cargo; then
    log_error "Cargo not found. Please run step 10-rust.sh first."
    exit 1
fi

install_crate() {
    local crate="$1"
    local bin="${2:-$crate}"
    if ! command_exists "$bin"; then
        log_info "Installing $crate..."
        execute cargo install "$crate"
    else
        log_success "$crate already installed."
    fi
}

install_crate "ripgrep" "rg"
install_crate "fd-find" "fd"
install_crate "eza"
install_crate "zoxide"
