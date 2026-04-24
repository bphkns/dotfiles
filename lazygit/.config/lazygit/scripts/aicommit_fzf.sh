#!/usr/bin/env bash
set -euo pipefail

for cmd in mise jq fzf git; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf '%s is required\n' "$cmd" >&2
    exit 1
  fi
done

if ! mise x node@25 -- npx --version >/dev/null 2>&1; then
  printf 'npx via mise node@25 is required\n' >&2
  exit 1
fi

results_file="$(mktemp -t lazygit-aicommit-results.XXXXXX)"
trap 'rm -f "$results_file"' EXIT INT TERM
printf '[]\n' > "$results_file"

selected="$(
  printf '\n' | fzf \
    --prompt="AI commit> " \
    --header="Select a message" \
    --height=100% \
    --layout=reverse \
    --info=inline \
    --with-nth=2.. \
    --delimiter=$'\t' \
    --with-shell="bash --noprofile --norc -c" \
    --preview-window="right:60%:wrap" \
    --preview "jq -r '.[{1}] | \"\(.subject // \"\")\n\n\(.body // \"\")\"' $results_file" \
    --bind "load:unbind(load)+reload-sync#mise x node@25 -- npx -y aicommit2 -i --output json 2>/dev/null | jq -s '.' > $results_file && jq -r 'to_entries[] | \"\\(.key)\\t\\(.value.subject)\"' $results_file#"
)" || exit 0

[[ -n "$selected" ]] || exit 0

index="${selected%%$'\t'*}"
subject="$(jq -r ".[${index}].subject // empty" "$results_file")"
body="$(jq -r ".[${index}].body // \"\"" "$results_file")"

[[ -n "$subject" ]] || exit 0

commit_args=(-e -m "$subject")
if [[ -n "$body" ]]; then
  commit_args+=(-m "$body")
fi

git commit "${commit_args[@]}"
