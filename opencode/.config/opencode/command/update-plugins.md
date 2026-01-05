---
description: Update all opencode plugins to their latest npm versions
---

# Update Plugins

Update all npm-based plugins in `~/.config/opencode/opencode.json` to their latest versions.

## Steps

1. Read `~/.config/opencode/opencode.json`
2. For each plugin in the `plugin` array:
   - Skip local paths (starting with `/` or `.`)
   - Extract package name (everything before `@` version suffix, or full name if no version)
   - Query npm for latest version: `npm view <package> version`
3. Update each plugin entry to `<package>@<latest-version>`
4. Write back the updated JSON

## Example

Before:

```json
"plugin": [
  "oh-my-opencode@2.12.0",
  "@zenobius/opencode-skillful",
  "/home/user/local-plugin"
]
```

After:

```json
"plugin": [
  "oh-my-opencode@2.12.4",
  "@zenobius/opencode-skillful@1.2.3",
  "/home/user/local-plugin"
]
```

## Notes

- Local paths are preserved unchanged
- `@latest` tags are replaced with pinned versions (faster startup)
- Run in parallel for speed: batch npm view calls
