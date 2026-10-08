#!/bin/sh
# Global skills for Claude Code and Codex: every skill in skills/ (project-*); from ECC documentation-lookup (uses the Context7 MCP from 50-mcp.sh) and unified-memory (uses the CLI from 65-memory.sh).
set -eu
. "$ROOT/scripts/lib.sh"
npx -y skills add "$ROOT" -s '*' -g -a claude-code -a codex -y
npx -y skills add affaan-m/ECC -s documentation-lookup -g -a claude-code -a codex -y
if ecc memory --help >/dev/null 2>&1; then  # skill needs the CLI from 65-memory.sh
  npx -y skills add affaan-m/ECC -s unified-memory -g -a claude-code -a codex -y
fi
