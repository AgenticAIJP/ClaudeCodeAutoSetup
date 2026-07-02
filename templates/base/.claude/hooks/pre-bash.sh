#!/bin/bash
# PreToolUse hook: blocks dangerous Bash commands before execution.
# Registered in .claude/settings.json (hooks.PreToolUse, matcher: "Bash").
# Exit code 2 = block the tool call. stderr is shown to Claude as the reason.

input=$(cat)

# Extract the "command" field from the hook JSON payload (jq if available).
if command -v jq >/dev/null 2>&1; then
  cmd=$(echo "$input" | jq -r '.tool_input.command // empty')
else
  cmd=$(echo "$input" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"')
fi

dangerous_patterns=(
  "rm -rf /"
  "rm -rf ~"
  "git push --force"
  "git push -f"
  "chmod 777"
  "> /dev/sda"
)

for pattern in "${dangerous_patterns[@]}"; do
  if [[ "$cmd" == *"$pattern"* ]]; then
    echo "Blocked by pre-bash hook: dangerous pattern \"$pattern\"" >&2
    exit 2
  fi
done

exit 0
