#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
install_upstream=1
fetch_ui=1
install_dependencies=1
configure_mcp=1

usage() {
	cat <<'EOF'
Usage: ./setup-ai-skills.sh [options]

Install source-managed AI skills, fetch licensed ui.sh skills, and expose the
shared skill directory to Claude Code. Run after `mise install`.

Options:
  --skip-upstream       Do not install public skills from their Git sources
  --skip-ui             Do not fetch licensed ui.sh skills
  --skip-dependencies   Do not install helper dependencies inside skills
  --skip-mcp            Do not configure Claude's uidotsh MCP server
  -h, --help            Show this help
EOF
}

log() {
	printf 'ai-skills: %s\n' "$*"
}

warn() {
	printf 'ai-skills: warning: %s\n' "$*" >&2
}

while (($#)); do
	case "$1" in
	--skip-upstream)
		install_upstream=0
		;;
	--skip-ui)
		fetch_ui=0
		;;
	--skip-dependencies)
		install_dependencies=0
		;;
	--skip-mcp)
		configure_mcp=0
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		printf 'ai-skills: error: unknown option: %s\n' "$1" >&2
		exit 2
		;;
	esac
	shift
done

if command -v skills >/dev/null 2>&1; then
	skills_command=(skills)
elif command -v npx >/dev/null 2>&1; then
	skills_command=(npx --yes skills@latest)
else
	printf 'ai-skills: error: skills CLI is unavailable; run `mise install` first\n' >&2
	exit 1
fi

agent_arguments=(
	--agent claude-code
	--agent codex
	--agent gemini-cli
	--agent github-copilot
	--agent opencode
	--agent pi
)

install_all_from() {
	local source="$1"
	log "installing skills from $source"
	"${skills_command[@]}" add "$source" \
		--global \
		--skill '*' \
		"${agent_arguments[@]}" \
		--yes
}

install_selected_from() {
	local source="$1"
	shift
	local skill
	local -a skill_arguments=()

	for skill in "$@"; do
		skill_arguments+=(--skill "$skill")
	done

	log "installing selected skills from $source"
	"${skills_command[@]}" add "$source" \
		--global \
		"${skill_arguments[@]}" \
		"${agent_arguments[@]}" \
		--yes \
		--full-depth
}

if ((install_upstream)); then
	install_selected_from vercel-labs/skills find-skills
	install_selected_from vercel-labs/agent-browser agent-browser
	install_selected_from mattpocock/skills \
		grill-me \
		grill-with-docs \
		handoff \
		improve-codebase-architecture \
		prototype \
		setup-matt-pocock-skills \
		tdd \
		triage
	install_all_from gokapso/agent-skills
	install_all_from nicobailon/visual-explainer
	install_all_from cloudflare/skills
	install_all_from pbakaus/impeccable
fi

if ((fetch_ui)); then
	if [[ -n ${UIDOTSH_TOKEN:-} ]]; then
		ui_destination="$HOME/.agents/skills"
		legacy_ui_root="$DOTFILES_DIR/agents/.agents/skills"
		legacy_probe="$ui_destination/add-dark-mode/SKILL.md"
		if [[ -L $legacy_probe ]] && resolved_probe=$(readlink -f -- "$legacy_probe"); then
			if [[ $resolved_probe == "$legacy_ui_root/"* ]]; then
				ui_destination=$legacy_ui_root
				log "using the legacy ignored ui.sh skill cache"
			fi
		fi

		python3 "$DOTFILES_DIR/scripts/fetch-ui-skills.py" \
			--destination "$ui_destination"
	else
		warn "UIDOTSH_TOKEN is not set; licensed ui.sh skills were skipped"
	fi
fi

if ((configure_mcp)) && command -v claude >/dev/null 2>&1; then
	if ! claude mcp get uidotsh >/dev/null 2>&1; then
		log "configuring uidotsh MCP for Claude Code"
		claude mcp add \
			--scope user \
			--transport http \
			uidotsh \
			'https://ui.sh/mcp?agent=claude' \
			--header 'Authorization: Bearer ${UIDOTSH_TOKEN}'
	fi
fi

# Claude Code uses ~/.claude/skills. Other configured harnesses discover the
# canonical ~/.agents/skills directory directly or are linked by the skills CLI.
mkdir -p "$HOME/.claude/skills"
for source in "$HOME/.agents/skills"/*; do
	[[ -d $source || -L $source ]] || continue
	name="${source##*/}"
	target="$HOME/.claude/skills/$name"

	if [[ -L $target && ! -e $target ]]; then
		rm -- "$target"
	fi
	if [[ ! -e $target && ! -L $target ]]; then
		ln -s "../../.agents/skills/$name" "$target"
	fi
done

if ((install_dependencies)); then
	if command -v npm >/dev/null 2>&1; then
		npm_command=(npm)
	elif command -v mise >/dev/null 2>&1; then
		npm_command=(mise exec node@25 -- npm)
	else
		npm_command=()
		warn "npm is unavailable; skill helper dependencies were skipped"
	fi

	if ((${#npm_command[@]})); then
		for name in automate-whatsapp integrate-whatsapp observe-whatsapp; do
			directory="$HOME/.agents/skills/$name"
			[[ -f $directory/package.json ]] || continue
			log "installing helper dependencies for $name"
			"${npm_command[@]}" install \
				--prefix "$directory" \
				--omit=dev \
				--ignore-scripts \
				--no-audit \
				--no-fund \
				--no-package-lock
		done
	fi
fi

missing=0
for directory in "$HOME/.agents/skills"/*; do
	[[ -d $directory || -L $directory ]] || continue
	if [[ ! -s $directory/SKILL.md ]]; then
		warn "missing SKILL.md: $directory"
		missing=1
	fi
done

((missing == 0)) || exit 1
log "setup complete"
