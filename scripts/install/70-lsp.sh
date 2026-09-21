#!/bin/sh
# Claude Code code intelligence for TypeScript and Python: diagnostics after each edit, go to definition.
set -eu
. "$ROOT/scripts/lib.sh"
have claude || exit 0
have typescript-language-server || npm i -g typescript typescript-language-server
have pyright-langserver || npm i -g pyright
plugins=$(claude plugin list 2>/dev/null || true)
for p in typescript-lsp pyright-lsp; do
  printf '%s\n' "$plugins" | grep -q "$p" || claude plugin install "$p@claude-plugins-official"
done
say "lsp: ok"
