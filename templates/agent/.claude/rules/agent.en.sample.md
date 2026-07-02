# How to use agent.md (guide for humans)

Rules for MCP / automation agent development.

## Why "one agent = one responsibility"

An agent with mixed responsibilities grows a bloated prompt,
becomes unstable, and is hard to debug.
Composing small agents is easier to test and improve.

## Before / After

✅ With rules → typed tool I/O, predictable failure behavior
❌ Without → an API key hardcoded in a prompt ends up leaked on GitHub

## Customization examples

```markdown
- All LLM calls go through the client.ts wrapper (for cost tracking)
- Inter-agent communication is JSON only; no free-text handoffs
- Execution logs go to logs/ in structured form (JSONL)
```
