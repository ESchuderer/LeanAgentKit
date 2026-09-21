#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
for s in "$CLAUDE_DIR"/plugins/cache/ponytail/ponytail/*/scripts/uninstall.js; do [ -f "$s" ] && node "$s"; done
have claude && { claude plugin uninstall ponytail@ponytail || true; }
have codex && { codex plugin remove ponytail || true; }
