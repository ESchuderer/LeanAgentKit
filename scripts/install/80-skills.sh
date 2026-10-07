#!/bin/sh
# Global skills for Claude Code and Codex: every skill in skills/ (project-*), documentation-lookup (ECC, uses the Context7 MCP from 50-mcp.sh).
set -eu
. "$ROOT/scripts/lib.sh"
npx -y skills add "$ROOT" -s '*' -g -a claude-code -a codex -y
npx -y skills add affaan-m/ECC -s documentation-lookup -g -a claude-code -a codex -y
