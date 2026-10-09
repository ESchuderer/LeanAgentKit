#!/bin/sh
# Claude Code code intelligence for TypeScript and Python, servers at the pinned versions: diagnostics after each edit, go to definition.
set -eu
. "$ROOT/scripts/lib.sh"
cli claude || exit 0
rc=0  # a failed server install must not skip the plugin installs
npm_g "typescript@$TYPESCRIPT" "typescript-language-server@$TS_LANGSERVER" || rc=1
npm_g "pyright@$PYRIGHT" || rc=1
# not registered before the first interactive session (scripts, containers, CI); a stale copy reports the plugins as not found
claude plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || claude plugin marketplace update claude-plugins-official >/dev/null 2>&1 || true
plugins=$(claude plugin list 2>/dev/null || true)
for p in typescript-lsp pyright-lsp; do
  printf '%s\n' "$plugins" | grep -q "$p" || claude plugin install "$p@claude-plugins-official"
done
[ "$rc" = 1 ] || say "lsp: ok"
exit "$rc"
