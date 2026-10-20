# Omarchy Fixes

The `omarchy/` directory is documentation and manually applied machine-specific
fixes. It is intentionally excluded from GNU Stow by `install.sh`.

## ProArt P16 NVIDIA Freezes

See [the RCA, released driver backport, verification, and rollback](nvidia-difr-rca.md).
The patch targets NVIDIA 610.57.04 on the ProArt P16 H7606WW and Omarchy kernels
only. It is manually installed into `/etc/dkms/`, never deployed by dotfile sync
or the portable installer. Other laptop models are guarded out even if the
config is copied manually.

After rebooting this ProArt into `linux-omarchy`, run
`~/dotfiles/omarchy/check-nvidia-difr.sh` to verify it is loaded.
Cross-machine safety check: `python3 ~/dotfiles/omarchy/test-nvidia-difr-portability.py`.

## AMD ProArt P16 Suspend

The ProArt P16 keeps the machine-local Limine parameter documented in the
[AMD GPIO suspend gist](https://gist.github.com/bphkns/59d1d30b2acda9287ea6d62f7087e7dd):

```text
gpiolib_acpi.ignore_interrupt=AMDI0030:00@16
```

The optional `fan-suspend.service` and `/usr/local/bin/fan-suspend.sh` were
removed because their ASUS hwmon writes failed. They are not portable dotfiles
and must not be installed on the Intel laptop.

## Locking While Plugged In

With the lid closed, locking turns off the external display after five seconds.
Logind counts only enabled external displays, so display power-off can remove
its docked exemption and trigger real suspend, disconnecting running agents.

`30-lid-on-ac.conf` ignores lid-triggered sleep on AC only. Battery lid-sleep,
manual suspend, and screen locking remain unchanged. Apply manually:

```sh
sudo install -Dm644 ~/dotfiles/omarchy/30-lid-on-ac.conf /etc/systemd/logind.conf.d/30-lid-on-ac.conf
sudo systemctl reload systemd-logind
busctl get-property org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager HandleLidSwitchExternalPower
```

Expected: `s "ignore"`. Reloading does not restart the desktop session.
Undo: remove the installed drop-in and reload logind.

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
