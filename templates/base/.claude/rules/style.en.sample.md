# How to use style.md (guide for humans)

> The neighboring `style.md` is the coding style guide Claude follows.
> Rewrite it freely to match your team's conventions.

## Why you need it

Without conventions, Claude writes in a subtly different style every session.
Naming, error handling, and comment language drift apart, and review costs grow.

## Before / After

### ✅ With style.md

→ Consistent style across all sessions; no need to repeat "comments in English"
→ The "write a test before fixing a bug" rule keeps fix quality stable

### ❌ Without it

→ Comments in one language today, another tomorrow; function length depends on mood
→ Errors silently swallowed by `catch {}` go unnoticed

## Customization examples

```markdown
- Indent with 2 spaces
- React components are function components only; no classes
- CSS uses Tailwind utility classes only
- Never commit console.log
```

## Tip

Let the linter handle everything a linter can check mechanically.
Write here only the **judgment calls a linter cannot express** — that is the efficient split.
