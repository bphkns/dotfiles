#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 84: AM Package Manager"

if command_exists am; then
    log_success "AM is already installed."
    exit 0
fi

log_info "Installing AM (AppMan)..."

# Download and run the official installer
# We use the system-wide installer for convenience, assuming sudo access as established in step 00
INSTALLER_URL="https://raw.githubusercontent.com/ivan-hc/AM/main/INSTALL"
INSTALLER_PATH="./AM-INSTALL"

if [ "$DRY_RUN" = "1" ]; then
    log_info "[DRY-RUN] Would download $INSTALLER_URL and run it with sudo."
else
    if curl -sL "$INSTALLER_URL" -o "$INSTALLER_PATH"; then
        chmod +x "$INSTALLER_PATH"
        # The installer requires interaction or sudo. 
        # The official one-liner is: sudo ./INSTALL
        if execute_sudo "$INSTALLER_PATH"; then
            log_success "AM installed successfully."
        else
            log_error "AM installation failed."
            rm -f "$INSTALLER_PATH"
            exit 1
        fi
        rm -f "$INSTALLER_PATH"
    else
        log_error "Failed to download AM installer."
        exit 1
    fi
fi
