# AI Agent Rules

- One agent = one responsibility. Never build a "does-everything agent"
- Tool inputs/outputs always have a defined schema (types); never pass raw any / dict
- Every tool that calls an external API has a timeout and a retry policy
- Agent prompts live in files under `agents/`, never embedded in code
- Secrets (API keys) come from environment variables; never hardcode in code or prompts
- Test agents against mocks; real-API tests are explicitly separated
