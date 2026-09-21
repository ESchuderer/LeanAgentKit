#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
have claude || exit 0
claude plugin uninstall typescript-lsp@claude-plugins-official || true
claude plugin uninstall pyright-lsp@claude-plugins-official || true
npm uninstall -g typescript-language-server pyright || true
