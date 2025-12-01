#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 92: Custom Tools (Mcphub, Hyprdynamicmonitors)"

# Ensure Cargo
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Hyprdynamicmonitors
if ! command_exists hyprdynamicmonitors; then
    log_info "Attempting to install hyprdynamicmonitors..."
    # Check if it's a known crate, otherwise this might fail.
    # We use '|| true' to prevent script failure if the crate doesn't exist publicly
    if cargo install hyprdynamicmonitors 2>/dev/null; then
        log_success "hyprdynamicmonitors installed."
    else
        log_warning "Could not install hyprdynamicmonitors via cargo (crate not found or build failed)."
        log_warning "If this is a private tool, please build it manually."
    fi
else
    log_success "hyprdynamicmonitors already installed."
fi

# Mcphub
if ! command_exists mcphub; then
    log_info "Attempting to install mcphub..."
    if cargo install mcphub 2>/dev/null; then
         log_success "mcphub installed."
    else
         log_warning "Could not install mcphub via cargo."
         # Try npm if available?
         if command_exists npm; then
             log_info "Trying npm..."
             if npm install -g mcphub 2>/dev/null; then
                 log_success "mcphub installed via npm."
             else
                 log_warning "Could not install mcphub via npm."
             fi
         fi
    fi
else
    log_success "mcphub already installed."
fi
