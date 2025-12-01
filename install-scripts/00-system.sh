#!/bin/bash
source "$(dirname "$0")/lib.sh"

log_info "Step 00: System Preparation"

ensure_dir "$HOME/.config"
ensure_dir "$HOME/.local/bin"
ensure_dir "$HOME/.local/share"
ensure_dir "$HOME/.local/share/fonts"

if command_exists apt-get; then
    log_info "Detected apt package manager."
    execute_sudo apt-get update
    execute_sudo apt-get install -y git curl wget build-essential cmake pkg-config libssl-dev \
        unzip tar python3 zsh stow \
        ffmpeg jq poppler-utils imagemagick \
        xclip wl-clipboard libmagickwand-dev \
        tmux alacritty bat

    # Bat symlink for Debian/Ubuntu
    if [ ! -f "$HOME/.local/bin/bat" ] && command_exists batcat; then
        log_info "Symlinking batcat to bat..."
        execute ln -sf /usr/bin/batcat "$HOME/.local/bin/bat"
    fi

    # 7zip handling
    if ! execute_sudo apt-get install -y 7zip 2>/dev/null; then
        execute_sudo apt-get install -y p7zip-full
    fi

elif command_exists pacman; then
    log_info "Detected pacman."
    execute_sudo pacman -Sy --noconfirm git curl wget base-devel cmake \
        ffmpeg 7zip jq poppler imagemagick xclip wl-clipboard \
        zsh unzip tar stow \
        tmux alacritty bat
else
    log_warning "Unknown package manager. Please ensure build dependencies and system tools are installed manually."
fi
