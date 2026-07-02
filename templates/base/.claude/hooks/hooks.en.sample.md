# What hooks are (guide for humans)

> Hooks run scripts automatically before/after Claude's tool calls.
> **Placing a script here is not enough** — it must be registered in `.claude/settings.json`.

## Hooks pre-registered in this template

| File | Event | Target | Action |
|------|-------|--------|--------|
| `pre-bash.sh` | PreToolUse | Bash | blocks dangerous commands (`rm -rf /` etc.) |
| `post-edit.sh` | PostToolUse | Edit / Write | auto-formats with Prettier after edits |

## How to register (settings.json)

```json
"hooks": {
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [{ "type": "command", "command": "bash .claude/hooks/pre-bash.sh" }]
    }
  ]
}
```

## Main events

| Event | When | Typical use |
|-------|------|-------------|
| `PreToolUse` | right before a tool runs | block dangerous ops, audit log |
| `PostToolUse` | right after a tool runs | auto-format, lint, tests |
| `Stop` | when Claude finishes responding | notification sound, build |
| `SessionStart` | when a session starts | env checks, context injection |

## How it works

- Hooks receive **JSON on stdin** (tool name, arguments, ...)
- In `PreToolUse`, **exit 2** blocks the tool call
  (whatever you write to stderr is passed to Claude as the reason)
- exit 0 means "all good, continue"

## Before / After

✅ With pre-bash.sh → an attempted `git push --force` is stopped just in time
❌ Without → all you can do is hope Claude never force-pushes

Rules (CLAUDE.md) are a **request**; hooks are **enforcement**.
Anything that must never happen belongs in a hook.
