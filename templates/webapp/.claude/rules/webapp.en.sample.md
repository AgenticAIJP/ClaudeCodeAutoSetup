# How to use webapp.md (guide for humans)

Rules that prevent the accidents Claude tends to cause in split frontend/backend apps.

## Typical accidents and the rules that stop them

| Common accident | Preventing rule |
|-----------------|-----------------|
| "Working code" that hits the DB from the frontend | force API access |
| Changing the API and forgetting the frontend | same-change boundary updates |
| Secret keys in the frontend env | env separation |

## Customization examples

```markdown
- Frontend uses Next.js App Router only; never write Pages Router code
- API paths require the /api/v1/ prefix
- Always ask before changing CORS settings
```

## Going further

Put a CLAUDE.md inside frontend/ and backend/ and Claude will read
those rules only when working in that directory
(the three-layer CLAUDE.md hierarchy).
