#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
rm -f "$CLAUDE_DIR/rules/00-leanagentkit-global.md"
agents=$CODEX_DIR/AGENTS.md
if [ -f "$agents" ]; then
  backup "$agents"
  awk '/<!-- leanagentkit:begin -->/ { s = 1; next } /<!-- leanagentkit:end -->/ { s = 0; next } !s' "$agents" | sed '1{/^$/d;}' > "$agents.tmp"
  mv "$agents.tmp" "$agents"; [ -s "$agents" ] || rm -f "$agents"
fi
say "rules: removed"
