#!/bin/sh
# skills/<name>/SKILL.md to Claude Code (~/.claude/skills) and Codex (~/.agents/skills).
set -eu
. "$ROOT/scripts/lib.sh"
for d in "$ROOT"/skills/*/; do
  n=$(basename "$d")
  mkdir -p "$CLAUDE_DIR/skills/$n" "$HOME/.agents/skills/$n"
  cp "$d/SKILL.md" "$CLAUDE_DIR/skills/$n/"; cp "$d/SKILL.md" "$HOME/.agents/skills/$n/"
  say "skill: $n"
done
