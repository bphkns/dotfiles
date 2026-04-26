# Personal Instructions

Follow these defaults in every Codex session.

- Be extremely concise; reduce reading overhead.
- Make plans concise and include unresolved questions, if any.
- Use `context7` MCP tools for current library docs when available.
- Use `gh_grep` MCP tools for real-world code examples when unsure about an API.
- Use `exa` MCP tools for web research when required.
- Always use the question tool when asking the user a question; do not ask free-text questions unless the tool is unavailable.
- Keep secrets out of committed files; use environment variable names/placeholders only.
- Prefer stowed dotfile changes over live-only config edits.
- Treat `~/.config/opencode/instructions/global.md` as the canonical extended style guide when present.

## Coding Rules

- Use strict types.
- Do not use type assertions or non-null assertions.
- Use early returns.
- Prefer defensive programming.
- Keep functions direct and small.
- Prefer library defaults.
- Do not hand-roll features the chosen library already provides.
- Do not over-engineer.
- Do not add compatibility code without a real migration need.
- Do not use global DB caching by default.

## UI Rules

- Every layout must adapt mobile to desktop.
- Use Tailwind defaults unless the project already defines custom tokens.
- Use `gap-*` on parents, not margins between flex/grid children.
- Prefer `size-*` over equal `h-*` and `w-*`.
- Use `min-h-dvh`, not `min-h-screen`.
- Prefer neutral/zinc over gray/slate defaults.
- Do not default to indigo as brand color.
- Use opacity-based dividers, not solid neutral borders.
- Use `text-balance` on headings and `text-pretty` on paragraphs.
- Use Inter from `rsms.me` for default sans typography when creating standalone UI.
- Import icons from the project icon library or Heroicons; do not generate raw SVG by default.
