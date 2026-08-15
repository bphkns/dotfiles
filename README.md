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

- Desktop: `omarchy-shell`, `xdph`, `omarchy-hooks`, `fontconfig`,
  `desktop-defaults`, `hypr-bindings`, `wireplumber`
- Terminals and shells: `alacritty`, `ghostty`, `tmux`, `zellij`, `bash`,
  `zsh`, `shell-profile`, `starship`
- Editors and developer tools: `nvim`, `mise`, `bat`, `btop`, `lazygit`,
  `mcphub`, `git`, `gh`, `ghui`, `cf`, `zed`, `ccstatusline`, `local-bin`
- AI tools: `claude`, `codex`, `opencode`, `pi`, `ai-skills`
- Other apps: **`herdr`**

The tracked Mise configuration is linked to `~/.config/mise/config.toml`, and
Herdr's portable configuration is linked to `~/.config/herdr/config.toml`.
Authentication, session history, logs, and machine-local integrations remain
local. The Git package adds a portable include while leaving credential helpers
and Git-AI runtime settings in `~/.config/git/config`.

Install or refresh only selected packages by naming them:

```bash
./install.sh --backup ai-skills herdr hypr-bindings omarchy-shell mise nvim ghostty
```

The script links configuration; it does not install every application. Create
the private shell environment from the secret-free template and fill it only
with newly rotated credentials:

```bash
install -m 600 ~/.config/dotfiles-private/env.sh.example \
  ~/.config/dotfiles-private/env.sh
${EDITOR:-nano} ~/.config/dotfiles-private/env.sh
source ~/.zprofile
```

Then install configured Mise tools as needed:

```bash
mise install
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
hyprctl reload
hyprctl configerrors
omarchy restart xcompose
omarchy restart audio
omarchy restart shell
omarchy restart terminal
omarchy restart tmux
systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal
```

## ProArt P16 hardware safety

The portable `hypr-bindings` package installs only personal Lua shortcuts.
Input and monitor settings use Omarchy's Quattro defaults, including automatic
monitor detection.

The Intel BE200 suspend scripts under [`omarchy/`](omarchy/) are documented for
the Lenovo Yoga only. Do **not** run them on the ProArt P16 without first
confirming that its Wi-Fi hardware and failure mode match.

## Secrets and machine-local state

Authentication files, credentials, tokens, caches, generated backups, and
agent runtime state are ignored. `~/.zprofile` only loads the ignored,
mode-600 `~/.config/dotfiles-private/env.sh`; the repository contains a
secret-free example. Rotate exposed credentials before placing replacement
values there. Sign in again on each machine instead of copying application
sessions into Git.

## Updating another machine

```bash
cd ~/dotfiles
git pull --ff-only
./install.sh --backup
mise install
./setup-ai-skills.sh
```
