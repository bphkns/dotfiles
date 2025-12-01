#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 95: Stowing Dotfiles"

# Folders to stow
FOLDERS=(
    "alacritty"
    "bash"
    "bat"
    "ghostty"
    "hyprdynamicmonitors"
    "lazygit"
    "mcphub"
    "mise"
    "nvim"
    "opencode"
    "ringboard"
    "scripts"
    "starship"
    "tmux"
    "xdph"
    "zsh"
)

if ! command_exists stow; then
    log_error "Stow is not installed. Please run step 00-system.sh."
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1

for folder in "${FOLDERS[@]}"; do
    if [ -d "$folder" ]; then
        log_info "Stowing $folder..."
        execute stow -d "$DOTFILES_DIR" -t "$HOME" -R "$folder"
    else
        log_warning "Folder $folder not found, skipping."
    fi
done
