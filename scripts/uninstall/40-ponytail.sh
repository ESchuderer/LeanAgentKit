#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
for s in "$CLAUDE_DIR"/plugins/cache/ponytail/ponytail/*/scripts/uninstall.js; do [ -f "$s" ] && node "$s"; done
if have claude; then claude plugin uninstall ponytail@ponytail || true; fi
if have codex; then codex plugin remove ponytail || true; fi
