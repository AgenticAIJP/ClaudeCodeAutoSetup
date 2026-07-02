# How to use architecture.md (guide for humans)

> The neighboring `architecture.md` is the "architectural constitution" Claude reads.
> It is imported from CLAUDE.md via `@.claude/rules/architecture.md`.

## Why you need it

Without instructions, Claude writes code along the **shortest path**.
That is fast, but tends to produce "everything in main" code that ignores layers.

## Before / After

### ✅ With architecture.md

You: "Add a payment feature"
→ Claude creates `src/core/payment.ts` and only calls it from the entry point
→ Dependency direction is preserved; the structure stays testable

### ❌ Without it

You: "Add a payment feature"
→ Claude writes payment logic directly in `main.ts` (shortest path)
→ After 3 features, main.ts is 500 lines and the architecture has collapsed

## Writing tips

- **Short, imperative sentences.** Long explanations dilute the effect (and consume context)
- Write "do X / don't do Y", not "X is recommended"
- Always include project-specific no-go zones (files that must not be touched, etc.)

## Customization examples

```markdown
- `src/legacy/` is read-only. Never modify
- All DB access goes through Repository classes
- Read env vars only in config.ts; never reference process.env directly
```
