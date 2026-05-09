#!/usr/bin/env bash
set -euo pipefail

FPS="${OMARCHY_SCREENSHARE_FPS:-30}"

case "$FPS" in
  ''|*[!0-9]*)
    printf 'OMARCHY_SCREENSHARE_FPS must be a number, got: %s\n' "$FPS" >&2
    exit 1
    ;;
esac

if ! command -v python3 >/dev/null 2>&1; then
  printf 'python3 is required to update config files safely.\n' >&2
  exit 1
fi

export OMARCHY_SCREENSHARE_FPS="$FPS"

python3 <<'PY'
import os
import shutil
import time
from pathlib import Path

home = Path.home()
xdg_config = Path(os.environ.get("XDG_CONFIG_HOME", home / ".config"))
xdg_data = Path(os.environ.get("XDG_DATA_HOME", home / ".local/share"))
fps = os.environ["OMARCHY_SCREENSHARE_FPS"]
stamp = time.strftime("%Y%m%d%H%M%S")


def backup(path: Path) -> None:
    if path.exists():
        backup_path = path.with_name(f"{path.name}.bak.{stamp}")
        shutil.copy2(path, backup_path)
        print(f"backup: {backup_path}")


def write_if_changed(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and path.read_text(encoding="utf-8") == content:
        print(f"unchanged: {path}")
        return

    backup(path)
    path.write_text(content, encoding="utf-8")
    print(f"updated: {path}")


xdph_conf = xdg_config / "hypr/xdph.conf"
write_if_changed(
    xdph_conf,
    f"""screencopy {{
    max_fps = {fps}
    force_shm = true
    allow_token_by_default = true
    custom_picker_binary = hyprland-preview-share-picker
}}
""",
)

picker_config = xdg_config / "hyprland-preview-share-picker/config.yaml"
write_if_changed(
    picker_config,
    """stylesheets: ["../omarchy/current/theme/hyprland-preview-share-picker.css"]
default_page: outputs

window:
  height: 500
  width: 1000

image:
  resize_size: 500
  widget_size: 150

windows:
  min_per_row: 3
  max_per_row: 999
  clicks: 1
  spacing: 12

outputs:
  clicks: 1
  spacing: 6
  show_label: false
  respect_output_scaling: true

region:
  command: slurp -f '%o@%x,%y,%w,%h'

hide_token_restore: true
debug: false
""",
)

chromium_flags = xdg_config / "chromium-flags.conf"
chromium_flags.parent.mkdir(parents=True, exist_ok=True)
lines = chromium_flags.read_text(encoding="utf-8").splitlines() if chromium_flags.exists() else []

for required in reversed(["--ozone-platform=wayland", "--ozone-platform-hint=wayland"]):
    if required not in lines:
        lines.insert(0, required)

feature = "WebRTCPipeWireCapturer"
feature_lines = [i for i, line in enumerate(lines) if line.startswith("--enable-features=")]

if feature_lines:
    for index in feature_lines:
        prefix, raw_features = lines[index].split("=", 1)
        features = [item.strip() for item in raw_features.split(",") if item.strip()]
        if feature not in features:
            features.append(feature)
        lines[index] = f"{prefix}={','.join(features)}"
else:
    lines.append(f"--enable-features={feature}")

write_if_changed(chromium_flags, "\n".join(lines) + "\n")

slack_user_desktop = xdg_data / "applications/slack.desktop"
slack_system_desktop = Path("/usr/share/applications/slack.desktop")
slack_exec = (
    "Exec=/usr/bin/slack --gtk-version=3 "
    "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer "
    "--ozone-platform=wayland --enable-wayland-ime -s %U"
)

if slack_user_desktop.exists():
    slack_lines = slack_user_desktop.read_text(encoding="utf-8").splitlines()
elif slack_system_desktop.exists():
    slack_lines = slack_system_desktop.read_text(encoding="utf-8").splitlines()
else:
    slack_lines = [
        "[Desktop Entry]",
        "Name=Slack",
        "StartupWMClass=Slack",
        "Comment=Slack Desktop",
        "GenericName=Slack Client for Linux",
        "Icon=slack",
        "Type=Application",
        "StartupNotify=true",
        "Categories=GNOME;GTK;Network;InstantMessaging;",
        "MimeType=x-scheme-handler/slack;",
    ]

for index, line in enumerate(slack_lines):
    if line.startswith("Exec="):
        slack_lines[index] = slack_exec
        break
else:
    insert_at = 1 if slack_lines and slack_lines[0] == "[Desktop Entry]" else len(slack_lines)
    slack_lines.insert(insert_at, slack_exec)

write_if_changed(slack_user_desktop, "\n".join(slack_lines) + "\n")
PY

SLACK_DESKTOP="${XDG_DATA_HOME:-$HOME/.local/share}/applications/slack.desktop"

if command -v desktop-file-validate >/dev/null 2>&1; then
  desktop-file-validate "$SLACK_DESKTOP"
fi

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "${XDG_DATA_HOME:-$HOME/.local/share}/applications"
fi

if ! command -v hyprland-preview-share-picker >/dev/null 2>&1; then
  printf 'warning: hyprland-preview-share-picker is not installed or not on PATH.\n' >&2
fi

systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service

if command -v hyprctl >/dev/null 2>&1; then
  hyprctl reload >/dev/null
  hyprctl configerrors
fi

printf '\nScreenshare config applied. Fully quit and reopen Chromium/Chrome and Slack.\n'
