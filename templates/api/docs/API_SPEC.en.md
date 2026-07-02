# API Specification

> ⚠️ When adding or changing an endpoint, update this file in the same change.

## Common

- Base URL: `/api/v1`
- Auth: <!-- TODO: e.g. Bearer token -->
- Error response format:

```json
{ "error": { "code": "STRING", "message": "STRING" } }
```

## Endpoints

### GET /health

Health check.

- Response: `200 OK` `{ "status": "ok" }`

<!-- TODO: add endpoints here -->
