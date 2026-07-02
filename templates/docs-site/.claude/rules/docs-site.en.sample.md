# How to use docs-site.md (guide for humans)

Rules for running a learning site or technical blog.

## Why examples/ is separated

Code inside articles "works when written" and then rots.
Keeping runnable code in `examples/` means it can be tested in CI,
preventing "tutorials that error when you run them".

## Before / After

✅ With rules → every article shares structure and tone; samples always run
❌ Without → each article structured differently; copy-pasted code that fails

## Customization examples

```markdown
- Consistent writing style across articles
- First use of a technical term always gets a one-line explanation
- Screenshots live in images/ with required alt text
```
