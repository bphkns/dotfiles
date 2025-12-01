#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 99: Final Setup"

# Ringboard
if [ -f "$DOTFILES_DIR/ringboard/setup.sh" ]; then
    log_info "Running Ringboard setup..."
    execute bash "$DOTFILES_DIR/ringboard/setup.sh"
fi

# Shell Change
if [ "$SHELL" != "$(which zsh)" ] && command_exists zsh; then
    log_info "Changing default shell to zsh..."
    log_warning "You may be asked for your password."
    execute chsh -s "$(which zsh)"
fi

log_success "Installation steps completed."
