#!/bin/bash
# PostToolUse hook: runs after Edit/Write.
# Auto-formats the edited file with Prettier when available.
# Always exits 0 — formatting failure should never block Claude.

input=$(cat)

if command -v jq >/dev/null 2>&1; then
  file_path=$(echo "$input" | jq -r '.tool_input.file_path // empty')
else
  file_path=$(echo "$input" \
    | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | head -1 | sed 's/.*: *"//; s/"$//')
fi

[ -z "$file_path" ] && exit 0
[ ! -f "$file_path" ] && exit 0

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.scss|*.html|*.md|*.yaml|*.yml)
    if command -v npx >/dev/null 2>&1; then
      npx --no-install prettier --write "$file_path" >/dev/null 2>&1
    fi
    ;;
esac

exit 0
