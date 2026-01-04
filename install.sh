#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Dotfiles Installation (Nix + Stow) ==="

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "Nix not found. Installing..."
    curl -L https://nixos.org/nix/install | sh -s -- --daemon
    echo "Please restart your shell and run this script again."
    exit 0
fi

# Enable flakes if not already
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

echo "=== Installing packages via home-manager ==="
cd "$DOTFILES_DIR"

# Build and activate home-manager configuration
nix run home-manager -- switch --flake .#bikash

echo "=== Stowing config files ==="
# List of stow packages (directories with configs)
STOW_PACKAGES=(
    alacritty
    bash
    bat
    ghostty
    lazygit
    local-bin
    mcphub
    mise
    nvim
    opencode
    scripts
    starship
    tmux
    xdph
    zsh
)

for pkg in "${STOW_PACKAGES[@]}"; do
    if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
        echo "Stowing $pkg..."
        stow -d "$DOTFILES_DIR" -t "$HOME" "$pkg" --restow
    fi
done

echo "=== Installation complete! ==="
echo "Restart your shell to apply changes."
