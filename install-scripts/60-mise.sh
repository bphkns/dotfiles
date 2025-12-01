#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 60: Mise"

if ! command_exists mise; then
    log_info "Installing Mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    
    # Optional: Install tools defined in config if we wanted, 
    # but strictly we are just installing the tool here.
else
    log_success "Mise already installed."
fi
