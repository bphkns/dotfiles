#!/usr/bin/env bash
# Claude Code status line mimicking the Starship gruvbox powerline prompt.
input=$(cat)
IFS=$'\x1f' read -r cwd model effort pct < <(
  echo "$input" | jq -r '[.workspace.current_dir // .cwd // "", .model.display_name // "", .effort.level // "", (.context_window.used_percentage // "" | tostring)] | join("\u001f")'
)

trunc() { # trunc <max> <text>
  if [ "${#2}" -le "$1" ]; then
    printf '%s' "$2"
    return
  fi
  printf '%s…' "${2:0:$(($1 - 1))}"
}

# Directory: folder name only, ~ for home.
dir="${cwd##*/}"
[ "$cwd" = "$HOME" ] && dir="~"
dir=$(trunc 16 "$dir")

# Git branch (no optional locks).
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short -q HEAD 2>/dev/null \
  || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
dirty=""
if [ -n "$branch" ] && [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | head -n1)" ]; then
  dirty=" *"
fi
branch=$(trunc 20 "$branch")

# Gruvbox dark palette (truecolor).
fg='38;2;251;241;199'
orange='214;93;14'; yellow='215;153;33'; aqua='104;157;106'; blue='69;133;136'; bg3='102;92;84'
arrow=$'\xee\x82\xb0'; cap=$'\xee\x82\xb6'; br=$'\xee\x82\xa0'

seg_prev=""
out=""
seg() { # seg <bg rgb> <text>
  if [ -z "$seg_prev" ]; then
    out+="\033[38;2;${1}m${cap}"
  else
    out+="\033[38;2;${seg_prev};48;2;${1}m${arrow}"
  fi
  out+="\033[${fg};48;2;${1}m $2 "
  seg_prev="$1"
}

seg "$orange" "$(whoami)"
seg "$yellow" "$dir"
[ -n "$branch" ] && seg "$aqua" "$br $branch$dirty"
[ -n "$model" ] && seg "$blue" "$model${effort:+ · $effort}"
[ -n "$pct" ] && seg "$bg3" "ctx $(printf '%.0f' "$pct")%"
out+="\033[0m\033[38;2;${seg_prev}m${arrow}\033[0m"
printf '%b' "$out"
