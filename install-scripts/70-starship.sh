#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 70: Starship"

if ! command_exists starship; then
    log_info "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    log_success "Starship already installed."
fi
