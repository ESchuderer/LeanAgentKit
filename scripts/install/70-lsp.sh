#!/bin/sh
# Claude Code code intelligence for TypeScript and Python: diagnostics after each edit, go to definition.
set -eu
. "$ROOT/scripts/lib.sh"
cli claude || exit 0
rc=0  # a failed server install must not skip the plugin installs
have typescript-language-server || npm_g typescript typescript-language-server || rc=1
have pyright-langserver || npm_g pyright || rc=1
plugins=$(claude plugin list 2>/dev/null || true)
for p in typescript-lsp pyright-lsp; do
  printf '%s\n' "$plugins" | grep -q "$p" || claude plugin install "$p@claude-plugins-official"
done
[ "$rc" = 1 ] || say "lsp: ok"
exit "$rc"
