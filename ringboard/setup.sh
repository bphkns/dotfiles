#!/bin/bash
# Ringboard setup script
# Run this after `stow ringboard` on a new machine

set -e

DATA_DIR="$HOME/.local/share/ringboard-data"
TARGET_DIR="$HOME/.local/share/clipboard-history"
RCLONE_BIN="$HOME/.local/bin/rclone"

echo "Setting up Ringboard..."

# Check for rclone
if [ ! -f "$RCLONE_BIN" ]; then
    echo "Installing rclone..."
    mkdir -p ~/.local/bin
    cd /tmp
    curl -LO https://downloads.rclone.org/rclone-current-linux-amd64.zip
    unzip -o rclone-current-linux-amd64.zip
    cp rclone-*/rclone ~/.local/bin/
    chmod +x ~/.local/bin/rclone
fi

# Check for rclone remote
if ! "$RCLONE_BIN" listremotes | grep -q "clipboard-hist:"; then
    echo "ERROR: rclone remote 'clipboard-hist' not configured!"
    echo "Run: ~/.local/bin/rclone config"
    echo "Create an S3/Cloudflare R2 remote named 'clipboard-hist'"
    exit 1
fi

# Create local data directory structure
mkdir -p "$DATA_DIR/direct" "$DATA_DIR/buckets"
touch "$DATA_DIR/direct/.keep"

# Remove existing target (file, dir, or broken symlink)
if [ -e "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
    echo "Removing existing $TARGET_DIR"
    rm -rf "$TARGET_DIR"
fi

# Create symlink to local data
ln -s "$DATA_DIR" "$TARGET_DIR"
echo "Created symlink: $TARGET_DIR -> $DATA_DIR"

# Sync from R2 if data exists remotely
echo "Syncing data from R2..."
"$RCLONE_BIN" sync clipboard-hist:clipboard-history "$DATA_DIR" --create-empty-src-dirs 2>/dev/null || true

# Initialize bisync
echo "Initializing bisync..."
"$RCLONE_BIN" bisync "$DATA_DIR" clipboard-hist:clipboard-history --create-empty-src-dirs --resync 2>/dev/null || true

# Reload and enable systemd services
echo "Enabling systemd services..."
systemctl --user daemon-reload
systemctl --user enable --now ringboard-server ringboard-wayland ringboard-sync.path ringboard-sync-pending.timer

echo "Ringboard setup complete!"
echo "Data syncs to Cloudflare R2 on every clipboard copy"
echo "Pending syncs are retried every 10 minutes when offline"
echo "Use Super+Ctrl+V to open clipboard history"
