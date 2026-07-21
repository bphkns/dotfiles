# AI skills

The dotfiles use three installation strategies so the public repository stays
portable without publishing licensed skill bodies.

## Stored in this repository

The `ai-skills` Stow package installs these locally maintained or pinned skills
under `~/.agents/skills`:

- `effect-tutor`
- `effect-ts-ai`
- `socratic-tutor`
- `defensive-css`
- `frontend-design`
- `react-modernization`
- `thermo-nuclear-code-quality-review`
- `caveman`
- `to-issues`
- `to-prd`
- `write-a-skill`
- `zoom-out`
- `plannotator-annotate`
- `plannotator-last`
- `plannotator-review`
- `plannotator-compound`
- `plannotator-setup-goal`
- `plannotator-visual-explainer`
- `omarchy` (a link to the skill shipped by Omarchy)

The pinned Matt Pocock skills retain their upstream MIT license under
[`docs/licenses/mattpocock-skills-MIT.txt`](licenses/mattpocock-skills-MIT.txt).
The restored Anthropic frontend-design skill retains its Apache 2.0 license
under
[the bundled Apache 2.0 license](licenses/anthropic-frontend-design.txt).

## Installed from public sources

`setup-ai-skills.sh` uses the Skills CLI to install current versions from:

- `vercel-labs/skills` — `find-skills`
- `vercel-labs/agent-browser` — browser automation
- `mattpocock/skills` — planning, handoff, architecture, prototyping, TDD, and
  triage skills
- `gokapso/agent-skills` — WhatsApp integration, automation, and observation
- `nicobailon/visual-explainer` — visual explanations
- `cloudflare/skills` — Cloudflare, Workers, Wrangler, Durable Objects, and
  related platform skills
- `pbakaus/impeccable` — interface design and review

The installer targets Claude Code, Codex, Gemini CLI, GitHub Copilot, OpenCode,
and Pi.

## Licensed ui.sh skills

The following subscription skills are deliberately not committed to this
public repository:

- `add-dark-mode`
- `brand-kit`
- `canonicalize-tailwind`
- `componentize`
- `dark-mode-image`
- `design`
- `ideas`
- `make-responsive`
- `markup-from-image`

Set `UIDOTSH_TOKEN` locally and run `./setup-ai-skills.sh`. The helper talks to
the authenticated uidotsh MCP server, adds the Agent Skills metadata Pi needs,
and writes the complete skill packages to `~/.agents/skills`. The token and
downloaded bodies remain outside Git.

Codex and OpenCode receive tracked uidotsh MCP configuration using the
`UIDOTSH_TOKEN` environment variable. The setup helper adds the equivalent
user-scoped MCP entry for Claude Code without committing `~/.claude.json`.

## Pi package skills

Pi's tracked settings install package-provided capabilities separately,
including Pi Lens, web research/Librarian, Teach Me, Literature Review,
Plannotator, Markdown preview, and the Claude bridge.
