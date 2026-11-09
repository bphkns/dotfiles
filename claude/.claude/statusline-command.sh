#!/usr/bin/env bash
# Claude Code status line: real Starship prompt plus Claude model and context.

input=$(cat)

cwd=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
model=$(jq -r '.model.display_name // empty' <<<"$input")
used_pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
vim_mode=$(jq -r '.vim.mode // empty' <<<"$input")

# zsh exports STARSHIP_SHELL, which would add zsh-only %{ %} escapes.
# Blank lines and the second prompt line (❯) don't belong in a status line.
prompt=$(cd "$cwd" 2>/dev/null && env -u STARSHIP_SHELL starship prompt 2>/dev/null | awk 'NF { print; exit }')

blue=$'\033[38;2;131;165;152m'
green=$'\033[38;2;184;187;38m'
yellow=$'\033[38;2;250;189;47m'
red=$'\033[38;2;251;73;52m'
dim=$'\033[38;2;168;153;132m'
reset=$'\033[0m'

claude="${blue}${model#Claude }"

if [[ -n "$used_pct" ]]; then
  pct=$(printf '%.0f' "$used_pct")
  color="$green"
  ((pct >= 60)) && color="$yellow"
  ((pct >= 80)) && color="$red"
  claude+=" ${color}${pct}%${dim} ctx"
fi

[[ -n "$vim_mode" ]] && claude+=" ${dim}${vim_mode}"

printf '%s%s%s\n' "$prompt" "$claude" "$reset"
