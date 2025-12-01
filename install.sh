#!/bin/bash

# Master Installation Script
# Orchestrates the execution of modular scripts in install-scripts/

set -e

# Parse args
DRY_RUN=0
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=1
            export DRY_RUN
            echo "!!! RUNNING IN DRY-RUN MODE !!!"
            ;;
    esac
done

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/install-scripts"
LOG_FILE="$DOTFILES_DIR/install.log"

# Source library for colors and logging
if [ -f "$SCRIPTS_DIR/lib.sh" ]; then
    source "$SCRIPTS_DIR/lib.sh"
else
    echo "Error: Library file not found at $SCRIPTS_DIR/lib.sh"
    exit 1
fi

log_info "Starting Dotfiles Installation..."
log_info "Logs will be written to $LOG_FILE"

# Make scripts executable
chmod +x "$SCRIPTS_DIR"/*.sh

# Find and run scripts
for script in "$SCRIPTS_DIR"/[0-9][0-9]-*.sh; do
    if [ -f "$script" ]; then
        script_name=$(basename "$script")
        log_info "Executing: $script_name"
        
        if "$script"; then
            log_success "Completed: $script_name"
        else
            log_error "Failed: $script_name"
            log_error "Please check the log file for details."
            log_error "Fix the issue and rerun this script to continue."
            exit 1
        fi
        echo "---------------------------------------------------"
    fi
done

log_success "All installation steps finished successfully!"
log_info "Please restart your shell or log out/in for changes to take full effect."
