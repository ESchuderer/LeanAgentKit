#!/bin/sh
# Global rules: Claude Code rules file; marked block at the top of Codex AGENTS.md.
set -eu
. "$ROOT/scripts/lib.sh"
mkdir -p "$CLAUDE_DIR/rules" "$CODEX_DIR"
cp "$ROOT/rules/global.md" "$CLAUDE_DIR/rules/00-leanagentkit-global.md"
say "claude rules: $CLAUDE_DIR/rules/00-leanagentkit-global.md"

agents=$CODEX_DIR/AGENTS.md
backup "$agents"
rest=$(mktemp)
[ -f "$agents" ] && awk '/<!-- leanagentkit:begin -->/ { s = 1; next } /<!-- leanagentkit:end -->/ { s = 0; next } !s' "$agents" | sed '1{/^$/d;}' > "$rest"
{ printf '<!-- leanagentkit:begin -->\n'; cat "$ROOT/rules/global.md"; printf '<!-- leanagentkit:end -->\n\n'; cat "$rest"; } > "$agents"
rm -f "$rest"
say "codex rules: block in $agents"
