#!/bin/sh
# ECC Memory Vault CLI (`ecc memory`) at the pinned version: file-based handoffs between Claude Code and Codex, stored in each repo's .ecc/memory/. CLI only, no MCP server.
set -eu
. "$ROOT/scripts/lib.sh"
npm_g "ecc-universal@$ECC_UNIVERSAL"
ecc memory --help >/dev/null 2>&1 || { say "memory vault: 'ecc memory' not available"; exit 1; }
say "memory vault: ok"
