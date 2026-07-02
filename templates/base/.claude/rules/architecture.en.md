# Architecture Rules

- Business logic lives in `src/core/`. Never write it directly in the entry point
- Respect the dependency direction: entry point → core → utils. Reverse imports are forbidden
- No shortcuts across layers just because "it works"
- Before adding any external library, explain why and get approval
- When changing a public interface (function signature / API), list the impact scope first
