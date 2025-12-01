#!/usr/bin/env bash
# lgaicm - LazyGit AI Commit Message (using Claude Code)
set -euo pipefail

MAX_DIFF_CHARS="${LGAICM_MAX_DIFF_CHARS:-8000}"
MAX_SUGGESTIONS="${LGAICM_MAX_SUGGESTIONS:-5}"
COMMIT_TYPE="${1:-}"

DIFF=$(git diff --cached --no-color 2>/dev/null || true)

if [[ -z "$DIFF" ]]; then
  echo "No staged changes" >&2
  exit 1
fi

# Truncate diff if too large
[[ ${#DIFF} -gt $MAX_DIFF_CHARS ]] && DIFF="${DIFF:0:$MAX_DIFF_CHARS}"

TYPE_HINT=""
[[ -n "$COMMIT_TYPE" ]] && TYPE_HINT="Use type: ${COMMIT_TYPE}. "

claude -p --model sonnet --max-turns 1 "${TYPE_HINT}Generate ${MAX_SUGGESTIONS} conventional commit messages for this diff. Output ONLY the messages, one per line, no numbers or bullets:

${DIFF}" 2>/dev/null | grep -E '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore)' | head -n "$MAX_SUGGESTIONS"
