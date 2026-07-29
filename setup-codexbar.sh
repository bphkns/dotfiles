#!/usr/bin/env bash
set -Eeuo pipefail

case "$(uname -m)" in
	x86_64) arch=x86_64 ;;
	aarch64 | arm64) arch=aarch64 ;;
	*)
		printf 'Unsupported architecture: %s\n' "$(uname -m)" >&2
		exit 1
		;;
esac

for command_name in curl git jq tar; do
	if ! command -v "$command_name" >/dev/null 2>&1; then
		printf 'Missing required command: %s\n' "$command_name" >&2
		exit 1
	fi
done

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

tag="$(curl -fsSL https://api.github.com/repos/steipete/CodexBar/releases/latest | jq -er '.tag_name')"
archive="CodexBarCLI-${tag}-linux-${arch}.tar.gz"
curl -fsSL "https://github.com/steipete/CodexBar/releases/download/${tag}/${archive}" -o "$tmp_dir/$archive"
tar -xzf "$tmp_dir/$archive" -C "$tmp_dir"

mkdir -p "$HOME/.local/bin"
install -m 0755 "$tmp_dir/CodexBarCLI" "$HOME/.local/bin/codexbar"

git clone --depth 1 https://github.com/Marouan-chak/codexbar-waybar.git "$tmp_dir/codexbar-waybar"
PATH="$HOME/.local/bin:$PATH" "$tmp_dir/codexbar-waybar/install.sh"
# The main Waybar config and stylesheet are managed by this dotfiles repo.
rm -f "$HOME/.config/waybar/modules/custom-codexbar.json" "$HOME/.config/waybar/user-style.css"

config_path="$HOME/.codexbar/config.json"
CODEXBAR_CONFIG="$config_path" "$HOME/.local/bin/codexbar" config enable --provider codex
CODEXBAR_CONFIG="$config_path" "$HOME/.local/bin/codexbar" config enable --provider claude
CODEXBAR_CONFIG="$config_path" "$HOME/.local/bin/codexbar" config validate

printf 'CodexBar %s installed. Restart Waybar to apply it.\n' "$tag"
