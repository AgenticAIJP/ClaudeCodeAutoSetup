# API Service Rules

- Keep routes thin: validation and conversion only. Business logic goes in services
- DB access only through models (or repositories); no raw queries from services
- When adding or changing an endpoint, update `docs/API_SPEC.md` in the same change
- Breaking changes (response shape etc.) always go through versioning (/v1, /v2)
- Validate every input. "The frontend already validates" is never a reason
- Use one unified error response format across the project
