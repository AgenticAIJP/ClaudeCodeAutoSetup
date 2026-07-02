# ClaudeCodeAutoSetup

**English** | [日本語](README.ja.md)

> Start your Claude Code project right, with one command.
> No confusion. Simple. Clean.

A tool that generates the ideal directory structure and config files for Claude Code.
Every config file ships with **human-readable documentation right next to it**
(`*.en.sample.md` / `*.ja.sample.md`), so you never hunt around wondering
"what is this file even for?"

🌐 Learning site: [code.jp.ai](https://code.jp.ai) (coming soon)
📦 Fully open source · non-profit · MIT License · 日本語 / English

## Usage

### The easiest way (no clone needed)

```bash
curl -fsSL https://raw.githubusercontent.com/AgenticAIJP/ClaudeCodeAutoSetup/main/setup.sh | bash
```

Only three questions:

1. Language — 日本語 / English
2. Project type (a number from 1 to 6)
3. Project name

### Clone and run

```bash
git clone https://github.com/AgenticAIJP/ClaudeCodeAutoSetup.git
cd ClaudeCodeAutoSetup
./setup.sh
```

### Non-interactive mode (scripts / CI)

```bash
./setup.sh 3 my-api-project en   # type 3 (API), English project files
./setup.sh 5 my-agent ja        # type 5 (AI Agent), Japanese project files
```

## Six project types

| # | Type | Best for | Signature structure |
|---|------|----------|---------------------|
| 1 | Generic base | when in doubt, start here | `src/ tests/ docs/ tasks/` |
| 2 | Web app | split frontend/backend apps | `frontend/ backend/` |
| 3 | API service | backends & microservices | `routes/ services/ models/` + API spec |
| 4 | CLI tool | command-line tools | `commands/ handlers/` |
| 5 | AI Agent | MCP & automation projects | `agents/ skills/ tools/` + MCP samples |
| 6 | Documentation | learning sites & tech blogs | `docs/ examples/ templates/` + boilerplate |

## What gets generated (generic base example)

```
my-project/
├── CLAUDE.md                        # Claude's "project briefing" (most important)
├── .claude/
│   ├── settings.json                # permissions & hooks (docs: settings.en.sample.md)
│   ├── rules/                       # architecture & coding style rules
│   │   ├── architecture.md          #   ← Claude reads this
│   │   ├── architecture.en.sample.md#   ← you read this (why, how, effects)
│   │   └── architecture.ja.sample.md#   ← Japanese teammates read this
│   ├── commands/                    # /refactor /review custom commands
│   ├── hooks/                       # dangerous-command blocking, auto-format
│   ├── prompts/                     # copy-paste prompt templates
│   └── memory.md                    # dynamic context across sessions
├── .mcp.sample.json                 # MCP server examples (GitHub / DB / ...)
├── docs/  src/  tests/  scripts/
└── tasks/                           # todo.md (plans) / lessons.md (mistakes log)
```

## How the bilingual layout works

- **Files Claude reads** (CLAUDE.md, rules, commands...) are generated in **one language** —
  the one you pick at setup. This keeps Claude's context clean and single-language.
- **Files humans read** (`*.sample.*`) ship in **both languages, side by side**,
  so English-speaking and Japanese-speaking teammates each find their explanation
  exactly where the confusion happens:

```
.claude/rules/architecture.md              ← Claude reads (the rules themselves)
.claude/rules/architecture.en.sample.md    ← English guide
.claude/rules/architecture.ja.sample.md    ← 日本語の解説
```

Sample files are excluded from Claude's view via `permissions.deny` →
`Read(./**/*.sample.*)`, so they cost zero context.

## FAQ

**Q. How is this different from the official `/init`?**
`/init` generates a single CLAUDE.md from existing code. This tool generates the
whole development scaffold — rules, hooks, commands, task management — with
documentation attached. Use both: scaffold with this tool, grow CLAUDE.md with `/init`.

**Q. What if I want to change the type later?**
Just add another type's rules under `.claude/rules/`. The structure is yours to grow.

**Q. Does it work on Windows?**
Yes, under Git Bash or WSL.

## Contributing

Issues and PRs welcome. This project is fully non-profit and accepts no donations.
The stronger the Claude Code ecosystem gets, the more everyone wins — that's the whole idea.

## License

[MIT](LICENSE)
