# What settings.json is (guide for humans)

> The neighboring `settings.json` is the Claude Code "project settings" file.
> This file (*.sample.md) is documentation for humans — Claude never reads it
> (excluded by the `Read(./**/*.sample.*)` rule in `permissions.deny`).

## Each field

### `$schema`

Enables autocomplete and validation in VS Code and other editors. Free win — just keep it.

### `permissions.allow` — operations allowed without confirmation

```json
"allow": ["Bash(npm run *)", "Bash(git diff *)"]
```

Register safe commands you don't want to approve every single time.

### `permissions.deny` — forbidden operations

```json
"deny": ["Read(./.env)", "Bash(rm -rf *)"]
```

- `Read(./.env)` → Claude **cannot read** .env (protects secrets)
- `Read(./**/*.sample.*)` → keeps these guide files out of Claude's view = **saves context**
- `Bash(rm -rf *)` → blocks destructive commands

> ⚠️ `ignorePatterns`, seen in older articles, is **deprecated**.
> "Hide files from Claude" is now done with `Read(...)` rules in `permissions.deny`.
>
> ⚠️ `.gitignore` is for Git only — it does **not** control what Claude reads.

### `hooks` — run scripts automatically around tool calls

Two hooks ship pre-registered in this template:

| Hook | When | What it does |
|------|------|--------------|
| `pre-bash.sh` | right before Bash runs | blocks dangerous commands |
| `post-edit.sh` | right after a file edit | auto-formats the file |

See `.claude/hooks/hooks.en.sample.md` for details.

## Where do MCP servers go?

Project-shared MCP servers go in **`.mcp.json` at the project root**,
not in settings.json (see `.mcp.sample.json` in the root for examples).

## With vs. without

✅ With settings.json → .env stays unread, dangerous commands are blocked, fewer confirmations
❌ Without → every action needs approval (slow), and secret files are visible to Claude
