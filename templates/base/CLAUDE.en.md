# {{PROJECT_NAME}}

> This file is the "project briefing" Claude Code reads first.
> Describe the big picture, the tech stack, and the rules to follow.
> Fill in the `<!-- TODO -->` spots for your project.

## Overview

<!-- TODO: 1-3 lines on what this project builds -->
{{PROJECT_NAME}} is a project for ____.

## Tech Stack

<!-- TODO: language, framework, DB (e.g. TypeScript / Next.js / Supabase) -->

- Language:
- Framework:
- Database:

## Directory Structure

```
{{PROJECT_NAME}}/
├── .claude/    # Claude Code config (rules, commands, hooks)
├── docs/       # design docs (help Claude see the big picture)
├── src/        # source code
├── tests/      # tests
├── scripts/    # automation scripts
└── tasks/      # task management (todo.md / lessons.md)
```

{{TYPE_SECTION}}

## Rules

Always follow these rule files:

@.claude/rules/architecture.md
@.claude/rules/style.md

## Workflow

1. Before starting work, write a plan in `tasks/todo.md` and get agreement
2. Proceed: implement → run tests → verify (never claim "done" without verification)
3. When a mistake or rework happens, record the cause in `tasks/lessons.md`

## Current State

@.claude/memory.md
