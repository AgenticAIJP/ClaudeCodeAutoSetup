# CLI Tool Rules

- One command = one file (`src/commands/`). Never put logic in main
- Real work lives in handlers; commands only call into them
- User-facing messages and errors go to stderr; pipeable output goes to stdout
- Return correct exit codes: success 0 / user error 1 / internal error 2
- Update `--help` text in the same change that adds or modifies a command
- Destructive operations (delete, overwrite) require a confirmation prompt or `--force`
