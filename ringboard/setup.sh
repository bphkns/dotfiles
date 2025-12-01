#!/bin/bash
# Ringboard setup script
# Run this after `stow ringboard` on a new machine

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
DATA_DIR="$DOTFILES_DIR/data"
TARGET_DIR="$HOME/.local/share/clipboard-history"

echo "Setting up Ringboard..."

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"

# Remove existing target (file, dir, or broken symlink)
if [ -e "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
    echo "Removing existing $TARGET_DIR"
    rm -rf "$TARGET_DIR"
fi

# Create parent directory
mkdir -p "$(dirname "$TARGET_DIR")"

# Create absolute symlink
ln -s "$DATA_DIR" "$TARGET_DIR"
echo "Created symlink: $TARGET_DIR -> $DATA_DIR"

# Reload and enable systemd services
echo "Enabling systemd services..."
systemctl --user daemon-reload
systemctl --user enable --now ringboard-server ringboard-wayland

echo "Ringboard setup complete!"
echo "Use Super+Ctrl+V to open clipboard history"
