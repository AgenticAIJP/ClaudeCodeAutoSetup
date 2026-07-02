# How to use api.md (guide for humans)

Rules that prevent the accidents Claude tends to cause in API services.

## The key point: keeping API_SPEC.md in sync

Claude is great at adding endpoints, but
**forgets to update the spec unless told**.
The "update in the same change" rule keeps the spec current, so the
next session's Claude reads an accurate spec (a virtuous cycle).

## Before / After

✅ With rules → routes stay ~10 lines, logic in services, spec auto-updated
❌ Without → 200-line route handlers, spec frozen on day one

## Customization examples

```markdown
- Auth always goes through middleware/auth.ts; no ad-hoc implementations
- Pagination is cursor-based everywhere
- Always ask before changing rate limits
```
