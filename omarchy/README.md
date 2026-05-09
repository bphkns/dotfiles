# Omarchy Fixes

## Screenshare

This records the Chrome/Chromium and Slack screenshare fix applied on Omarchy/Hyprland.

Run it after a fresh install or whenever an update resets the relevant files:

```sh
~/dotfiles/omarchy/fix-screenshare.sh
```

What the script does:

- Writes `~/.config/hypr/xdph.conf` with `max_fps = 30`, `force_shm = true`, `allow_token_by_default = true`, and `hyprland-preview-share-picker`.
- Writes `~/.config/hyprland-preview-share-picker/config.yaml` so monitor/window selection is single-click.
- Ensures `~/.config/chromium-flags.conf` uses Wayland and enables `WebRTCPipeWireCapturer`.
- Creates or updates `~/.local/share/applications/slack.desktop` so Slack launches on Wayland with `WebRTCPipeWireCapturer`.
- Restarts `xdg-desktop-portal-hyprland` and `xdg-desktop-portal`.
- Reloads Hyprland and prints config errors if `hyprctl` is available.

If screen sharing is still unstable on a high-resolution display, lower the capture FPS:

```sh
OMARCHY_SCREENSHARE_FPS=15 ~/dotfiles/omarchy/fix-screenshare.sh
```

After running it, fully quit and reopen Chromium/Chrome and Slack so they pick up the new flags.

## Intel BE200 Wi-Fi Suspend

This records the minimal Wi-Fi suspend workaround for this machine:

- Laptop: Lenovo Yoga Pro 7 14IAH10
- Wi-Fi: Intel BE200/BE401 class device at PCI `0000:01:00.0`
- Driver stack: `iwlwifi` with op mode `iwlmld`
- Failure signature: `Hardware became unavailable upon resume`, `timeout waiting for FW reset ACK`, and `0xFFFFFFFF` after s2idle resume

The active workaround only disables PCI D3cold for the Wi-Fi device. It does not unload/reload Wi-Fi modules and does not stop `iwd` or `systemd-networkd` during suspend.

Install or refresh the workaround:

```sh
~/dotfiles/omarchy/fix-intel-be200-wifi.sh
```

What the script does:

- Installs `80-intel-be200-disable-d3cold.rules` to `/etc/udev/rules.d/`.
- Reloads udev and immediately applies `d3cold_allowed=0` to PCI device `0000:01:00.0` if present.
- Removes the older sleep hook from `/usr/lib/systemd/system-sleep/` or `/etc/systemd/system-sleep/` if it exists.

Verify without suspending:

```sh
cat /sys/bus/pci/devices/0000:01:00.0/d3cold_allowed
```

Expected output:

```text
0
```

After a manual suspend/resume test, check Wi-Fi and recent driver errors:

```sh
iwctl station list
journalctl -b -k --since '-5 min' --grep='iwlwifi|timeout waiting for FW reset ACK|Hardware became unavailable' --no-pager
```

Side effect:

- Sleep battery drain can be slightly higher because the Wi-Fi PCI device is kept out of its deepest low-power state.

Undo:

```sh
~/dotfiles/omarchy/undo-intel-be200-wifi.sh
```
