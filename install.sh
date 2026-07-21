#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backups/$(date +%Y%m%d-%H%M%S)"

# Every portable Stow package is installed by default. Keep this list explicit so
# a new top-level directory cannot unexpectedly overwrite files in $HOME.
PORTABLE_PACKAGES=(
	ai-skills
	ai-usagebar
	alacritty
	bash
	bat
	claude
	codex
	fontconfig
	ghostty
	herdr
	lazygit
	local-bin
	mcphub
	mise
	nvim
	omarchy-hooks
	opencode
	pi
	starship
	tmux
	waybar
	xdph
	zellij
	zsh
)

# The checked-in monitor profile belongs to the Lenovo Yoga and must be reviewed
# before it is linked on another computer, especially the ProArt P16.
MACHINE_SPECIFIC_PACKAGES=(hypr)
NON_STOW_DIRECTORIES=(agents docs omarchy scripts)

dry_run=0
backup_conflicts=0
allow_machine_specific=0
backed_up=0
requested_packages=()
selected_packages=()
conflict_packages=()
conflict_paths=()
unsafe_paths=()

usage() {
	cat <<'EOF'
Usage: ./install.sh [options] [package ...]

Install all portable dotfile packages with GNU Stow. If package names are
provided, only those packages are installed.

Options:
  --dry-run                    Show packages and conflicts without changing files
  --backup                     Move conflicting files into ~/.local/state first
  --allow-machine-specific     Permit the Lenovo-specific hypr package
  -h, --help                   Show this help

Recommended on a new Omarchy machine:
  ./install.sh --dry-run
  ./install.sh --backup
EOF
}

log() {
	printf 'dotfiles: %s\n' "$*"
}

warn() {
	printf 'dotfiles: warning: %s\n' "$*" >&2
}

die() {
	printf 'dotfiles: error: %s\n' "$*" >&2
	exit 1
}

contains() {
	local needle="$1"
	shift
	local item

	for item in "$@"; do
		[[ $item == "$needle" ]] && return 0
	done

	return 1
}

package_selected() {
	contains "$1" "${selected_packages[@]}"
}

list_package_files() {
	local package="$1"
	git -C "$DOTFILES_DIR" ls-files -z --cached --others --exclude-standard -- "$package/"
}

package_has_files() {
	local package="$1"
	local first_path=""

	IFS= read -r first_path < <(git -C "$DOTFILES_DIR" ls-files --cached --others --exclude-standard -- "$package/")
	[[ -n $first_path ]]
}

path_is_ignored() {
	local package="$1"
	local relative_path="$2"
	local ignore_file pattern

	for ignore_file in "$DOTFILES_DIR/.stow-local-ignore" "$DOTFILES_DIR/$package/.stow-local-ignore"; do
		[[ -f $ignore_file ]] || continue

		while IFS= read -r pattern || [[ -n $pattern ]]; do
			[[ $pattern =~ ^[[:space:]]*$ ]] && continue
			[[ $pattern =~ ^[[:space:]]*# ]] && continue
			[[ "/$relative_path" =~ $pattern ]] && return 0
		done <"$ignore_file"
	done

	return 1
}

# Prints one of: clear, managed, or unsafe:<path>.
classify_parent_path() {
	local package="$1"
	local relative_path="$2"
	local parent_path="${relative_path%/*}"
	local current="$HOME"
	local expected="$DOTFILES_DIR/$package"
	local component
	local -a components=()

	[[ $parent_path != "$relative_path" ]] || {
		printf 'clear\n'
		return
	}

	IFS='/' read -r -a components <<<"$parent_path"
	for component in "${components[@]}"; do
		current="$current/$component"
		expected="$expected/$component"

		if [[ -L $current ]]; then
			if [[ $(realpath -m -- "$current") == "$(realpath -m -- "$expected")" ]]; then
				printf 'managed\n'
			else
				printf 'unsafe:%s\n' "$current"
			fi
			return
		fi

		if [[ -e $current && ! -d $current ]]; then
			printf 'unsafe:%s\n' "$current"
			return
		fi
	done

	printf 'clear\n'
}

target_is_stow_link() {
	local source="$1"
	local target="$2"
	local expected_link

	[[ -L $target ]] || return 1
	expected_link="$(realpath -s --relative-to="$(dirname -- "$target")" -- "$source")"
	[[ $(readlink -- "$target") == "$expected_link" ]]
}

scan_conflicts() {
	local package tracked_path relative_path source target parent_state

	for package in "${selected_packages[@]}"; do
		while IFS= read -r -d '' tracked_path; do
			relative_path="${tracked_path#"$package/"}"
			[[ $relative_path != ".stow-local-ignore" ]] || continue
			path_is_ignored "$package" "$relative_path" && continue

			source="$DOTFILES_DIR/$tracked_path"
			target="$HOME/$relative_path"
			parent_state="$(classify_parent_path "$package" "$relative_path")"

			case "$parent_state" in
			managed)
				continue
				;;
			unsafe:*)
				unsafe_paths+=("$target (blocked by ${parent_state#unsafe:})")
				continue
				;;
			esac

			target_is_stow_link "$source" "$target" && continue

			if [[ -e $target || -L $target ]]; then
				conflict_packages+=("$package")
				conflict_paths+=("$relative_path")
			fi
		done < <(list_package_files "$package")
	done
}

move_to_backup() {
	local target="$1"
	local relative_path="$2"
	local destination="$BACKUP_ROOT/$relative_path"

	[[ -e $target || -L $target ]] || return 0
	[[ ! -e $destination && ! -L $destination ]] || die "backup already exists: $destination"

	mkdir -p -- "$(dirname -- "$destination")"
	mv -T -- "$target" "$destination"
	backed_up=1
	log "backed up ~/$relative_path"
}

copy_to_backup() {
	local target="$1"
	local relative_path="${target#"$HOME/"}"
	local destination="$BACKUP_ROOT/$relative_path"

	[[ -e $target || -L $target ]] || return 0
	[[ ! -e $destination && ! -L $destination ]] || return 0

	mkdir -p -- "$(dirname -- "$destination")"
	cp -a -- "$target" "$destination"
	backed_up=1
}

ensure_line() {
	local file="$1"
	local line="$2"
	local existing

	if [[ -f $file ]]; then
		while IFS= read -r existing || [[ -n $existing ]]; do
			[[ $existing == "$line" ]] && return 0
		done <"$file"
		copy_to_backup "$file"
	elif [[ -e $file || -L $file ]]; then
		die "expected a regular file: $file"
	fi

	mkdir -p -- "$(dirname -- "$file")"
	printf '\n%s\n' "$line" >>"$file"
}

link_omarchy_nvim_theme() {
	local source="$HOME/.config/omarchy/current/theme/neovim.lua"
	local target="$HOME/.config/nvim/lua/plugins/theme.lua"
	local relative_path="${target#"$HOME/"}"

	if [[ ! -e $source ]]; then
		warn "Omarchy Neovim theme not found; skipped $target"
		return
	fi

	if [[ -L $target && $(realpath -m -- "$target") == "$(realpath -m -- "$source")" ]]; then
		return
	fi

	move_to_backup "$target" "$relative_path"
	mkdir -p -- "$(dirname -- "$target")"
	ln -s -- "$source" "$target"
}

load_shared_stow_ignores() {
	local ignore_file="$DOTFILES_DIR/.stow-local-ignore"
	local pattern

	[[ -f $ignore_file ]] || return 0
	while IFS= read -r pattern || [[ -n $pattern ]]; do
		[[ $pattern =~ ^[[:space:]]*$ ]] && continue
		[[ $pattern =~ ^[[:space:]]*# ]] && continue
		# Command-line ignores match basenames. Path-aware expressions remain in
		# package-local ignore files and are used by the conflict scanner above.
		[[ $pattern == */* ]] && continue
		stow_args+=("--ignore=$pattern")
	done <"$ignore_file"
}

while (($#)); do
	case "$1" in
	--dry-run)
		dry_run=1
		;;
	--backup)
		backup_conflicts=1
		;;
	--allow-machine-specific)
		allow_machine_specific=1
		;;
	-h | --help)
		usage
		exit 0
		;;
	--)
		shift
		requested_packages+=("$@")
		break
		;;
	-*)
		die "unknown option: $1"
		;;
	*)
		requested_packages+=("$1")
		;;
	esac
	shift
done

command -v git >/dev/null 2>&1 || die "git is required"
command -v stow >/dev/null 2>&1 || die "GNU Stow is required (run: omarchy pkg add stow)"

if ((${#requested_packages[@]})); then
	selected_packages=("${requested_packages[@]}")
else
	selected_packages=("${PORTABLE_PACKAGES[@]}")
fi

# De-duplicate while preserving the manifest order supplied by the user.
deduplicated_packages=()
for package in "${selected_packages[@]}"; do
	contains "$package" "${deduplicated_packages[@]}" || deduplicated_packages+=("$package")
done
selected_packages=("${deduplicated_packages[@]}")

for package in "${selected_packages[@]}"; do
	[[ $package =~ ^[A-Za-z0-9._-]+$ ]] || die "invalid package name: $package"
	[[ -d $DOTFILES_DIR/$package ]] || die "package does not exist: $package"
	contains "$package" "${NON_STOW_DIRECTORIES[@]}" && die "$package is not a Stow package"

	if contains "$package" "${MACHINE_SPECIFIC_PACKAGES[@]}" && ((!allow_machine_specific)); then
		die "$package is Lenovo-specific; review it and pass --allow-machine-specific to install it"
	fi

	package_has_files "$package" || die "package has no versioned files: $package"
done

if ! command -v omarchy >/dev/null 2>&1; then
	warn "Omarchy was not detected; continuing with Stow only"
fi

log "target: $HOME"
log "packages: ${selected_packages[*]}"
scan_conflicts

if ((${#unsafe_paths[@]})); then
	printf 'dotfiles: unsafe parent paths detected:\n' >&2
	printf '  %s\n' "${unsafe_paths[@]}" >&2
	die "replace those parent symlinks/files manually, then rerun"
fi

if ((${#conflict_paths[@]})); then
	printf 'dotfiles: conflicting files:\n'
	for index in "${!conflict_paths[@]}"; do
		printf '  %-16s ~/%s\n' "${conflict_packages[$index]}" "${conflict_paths[$index]}"
	done

	if ((dry_run)); then
		if ((backup_conflicts)); then
			log "dry run: the files above would be moved to $BACKUP_ROOT"
		else
			log "dry run: rerun with --backup to preserve and replace them"
		fi
		exit 0
	fi

	((backup_conflicts)) || die "conflicts found; rerun with --backup or resolve them manually"

	for index in "${!conflict_paths[@]}"; do
		move_to_backup "$HOME/${conflict_paths[$index]}" "${conflict_paths[$index]}"
	done
fi

declare -a stow_args=(
	--no-folding
	--restow
	--dir="$DOTFILES_DIR"
	--target="$HOME"
)
load_shared_stow_ignores

if ((dry_run)); then
	stow --simulate --verbose=1 "${stow_args[@]}" "${selected_packages[@]}"
	log "dry run complete; no files changed"
	exit 0
fi

# Verify the complete operation after conflicts have been moved but before
# creating any links. This catches ignored or untracked files Stow can see.
stow --simulate --verbose=1 "${stow_args[@]}" "${selected_packages[@]}" >/dev/null
stow "${stow_args[@]}" "${selected_packages[@]}"

if package_selected ghostty; then
	ensure_line "$HOME/.config/ghostty/config" 'config-file = ?"~/.config/ghostty/dotfiles.conf"'
fi

if package_selected tmux; then
	ensure_line "$HOME/.config/tmux/tmux.conf" 'source-file ~/.config/tmux/dotfiles.conf'
fi

if package_selected nvim; then
	link_omarchy_nvim_theme
fi

if ((backed_up)); then
	log "backups: $BACKUP_ROOT"
fi

log "installation complete"
package_selected ai-skills && log "install source-managed skills: $DOTFILES_DIR/setup-ai-skills.sh"
package_selected waybar && log "apply Waybar changes: omarchy restart waybar"
package_selected xdph && log "apply screen-share changes: systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal"
(package_selected ghostty || package_selected alacritty) && log "apply terminal changes: omarchy restart terminal"
package_selected tmux && log "apply tmux changes: omarchy restart tmux"
