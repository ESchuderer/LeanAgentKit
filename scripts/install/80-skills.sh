#!/bin/sh
# Global skills for Claude Code and Codex: every skill in skills/ (project-*); from ECC at the pinned commit: documentation-lookup (uses the Context7 MCP from 50-mcp.sh) and, when the CLI from 65-memory.sh is present, unified-memory.
set -eu
. "$ROOT/scripts/lib.sh"
export DO_NOT_TRACK=1  # skills CLI telemetry, this process only (never set it for Claude Code: README, Tips)
npx -y "skills@$SKILLS_CLI" add "$ROOT" -s '*' -g -a claude-code -a codex -y
mem=""; ecc memory --help >/dev/null 2>&1 && mem="-s unified-memory"
npx -y "skills@$SKILLS_CLI" add "https://github.com/affaan-m/ECC/tree/$ECC_SHA" -s documentation-lookup $mem -g -a claude-code -a codex -y
