# Shell: Non-Interactive Only

This shell has NO TTY. Commands that wait for input hang and timeout.

## Rules
1. Assume `CI=true` - headless pipeline
2. Always use `-y`, `--yes`, `--force`, `--no-edit`, `--non-interactive` flags
3. Never use editors (`vim`, `nano`), pagers (`less`, `more`, `man`), or REPLs (`python`, `node` without `-c`/`-e`)
4. Never use interactive git (`git add -p`, `git rebase -i`, `git commit` without `-m`)
5. Prefer Read/Write/Edit tools over shell for file manipulation
6. Pipe `yes |` or use heredocs when no non-interactive flag exists
7. Use `timeout 30` as last resort for potentially-hanging commands
