#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 85: Ghostty Terminal"

if command_exists ghostty; then
    log_success "Ghostty already installed."
    exit 0
fi

# Try installing via AM (App Manager)
if command_exists am; then
    log_info "Installing Ghostty via AM..."
    # AM usually needs root for system-wide install (-i)
    if execute_sudo am -i ghostty; then
        log_success "Ghostty installed via AM."
        exit 0
    else
        log_error "Failed to install Ghostty via AM."
        exit 1
    fi
else
    log_warning "AM (App Manager) not found. Cannot auto-install Ghostty."
    log_info "Please ensure step 84-am.sh ran successfully."
fi
