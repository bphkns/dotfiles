# Personal Instructions

Follow the shared global instructions from OpenCode when available:

@~/.config/opencode/instructions/global.md

Claude-specific defaults:

- Use `context7` MCP tools for current library docs when available.
- Use `gh_grep` MCP tools for real-world code examples when unsure about an API.
- Use `exa` MCP tools for web research when required.
- Keep secrets out of committed files; use environment variable names/placeholders only.
- Prefer stowed dotfile changes over live-only config edits.
