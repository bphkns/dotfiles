# Omarchy dotfiles

Personal Omarchy configuration managed with
[GNU Stow](https://www.gnu.org/software/stow/). The portable installer links
all app configurations by default, including **Herdr** (`herdr`).

## Set up the ProArt P16

Start from a working Omarchy installation using the same Linux username
(`bikash`):

```bash
omarchy pkg add git stow
git clone git@github.com:bphkns/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Inspect conflicts without changing anything.
./install.sh --dry-run

# Preserve stock/existing files, then replace them with Stow links.
./install.sh --backup
```

Conflicting files are moved to:

```text
~/.local/state/dotfiles/backups/<timestamp>/
```

The installer uses `--no-folding`, so account files and other machine-local
state can safely coexist beside the managed links.

## What is stowed

The default install includes every portable package in the repository:

- Desktop: `waybar`, `xdph`, `omarchy-hooks`, `fontconfig`
- Terminals and shells: `alacritty`, `ghostty`, `tmux`, `zellij`, `bash`,
  `zsh`, `starship`
- Editors and developer tools: `nvim`, `mise`, `bat`, `lazygit`, `mcphub`,
  `local-bin`
- AI tools: `claude`, `codex`, `opencode`, `pi`, `ai-usagebar`, `ai-skills`
- Other apps: **`herdr`**

The tracked Mise configuration is linked to `~/.config/mise/config.toml`, and
Herdr's complete configuration is linked to `~/.config/herdr/config.toml`.

Install or refresh only selected packages by naming them:

```bash
./install.sh --backup ai-skills herdr mise nvim ghostty
```

The script links configuration; it does not install every application. After
the first install, install configured Mise tools and the Waybar usage helper as
needed:

```bash
mise install
cargo install ai-usagebar
```

Install public AI skills and fetch licensed ui.sh skills after setting your
local `UIDOTSH_TOKEN`:

```bash
./setup-ai-skills.sh
```

The token and licensed ui.sh skill bodies are never committed. See
[`docs/ai-skills.md`](docs/ai-skills.md) for the complete inventory and source
policy.

Then apply running-app configuration:

```bash
omarchy restart waybar
omarchy restart terminal
omarchy restart tmux
systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal
```

## ProArt P16 hardware safety

The default installer intentionally skips
`hypr/.config/hypr/monitors.conf`. That file contains the old Lenovo Yoga panel
mode and specific external-monitor identifiers. On the ProArt P16, keep
Omarchy's stock auto-detected monitor configuration until a P16-specific
profile is created.

The Intel BE200 suspend scripts under [`omarchy/`](omarchy/) are documented for
the Lenovo Yoga only. Do **not** run them on the ProArt P16 without first
confirming that its Wi-Fi hardware and failure mode match.

To reinstall the old Lenovo monitor profile explicitly:

```bash
./install.sh --backup --allow-machine-specific hypr
hyprctl reload
hyprctl configerrors
```

## Secrets and machine-local state

Authentication files, credentials, tokens, caches, generated backups, and
agent runtime state are ignored. Sign in again on the new machine instead of
copying secrets into Git. The `ai-usagebar` config comments document where to
place its per-account OAuth files.

## Updating another machine

```bash
cd ~/dotfiles
git pull --ff-only
./install.sh --backup
mise install
./setup-ai-skills.sh
```
