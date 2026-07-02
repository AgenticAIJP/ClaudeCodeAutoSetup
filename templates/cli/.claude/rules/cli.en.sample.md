# How to use cli.md (guide for humans)

Rules that prevent the accidents Claude tends to cause in CLI tools.

## Why the stdout / stderr split matters

CLI tools get piped into other commands:

```bash
mytool list | grep foo   # logs mixed into stdout break grep
```

Claude tends to reach for "just console.log", so make it an explicit rule.

## Before / After

✅ With rules → `mytool list | jq .` works; exit codes make it CI-ready
❌ Without → progress messages leak into stdout and break every pipe

## Customization examples

```markdown
- Argument parsing uses commander; no hand-rolled parsing
- Color output must be disableable with --no-color
- Config lives at ~/.config/mytool/config.json, fixed
```
