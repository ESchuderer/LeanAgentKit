#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
for s in "$CLAUDE_DIR"/plugins/cache/*/ponytail/*/scripts/uninstall.js; do [ -f "$s" ] && node "$s"; done
if have claude; then claude plugin marketplace remove leanagentkit || true; fi  # uninstalls its plugins
if have codex; then codex plugin remove ponytail@leanagentkit || true; codex plugin marketplace remove leanagentkit || true; fi
rm -f "${LAK_STATE_DIR:-$HOME/.leanagentkit}/ponytail-codex.sha"
