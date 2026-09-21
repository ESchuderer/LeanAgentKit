#!/bin/sh
# One shot: global rules, agent settings, tools. Delete a line below to skip that step.
# Windows: run from Git Bash. Needs git, node/npm, and the claude and codex CLIs on PATH.
set -u
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd); export ROOT
BACKUP_DIR="${LAK_STATE_DIR:-$HOME/.leanagentkit}/backups/$(date +%Y%m%d-%H%M%S)-install"; export BACKUP_DIR
failed=""
run() { printf '\n== %s\n' "$1"; sh "$ROOT/scripts/install/$1" || failed="$failed $1"; }

run 10-rules.sh
run 20-settings.sh
run 30-rtk.sh
run 40-ponytail.sh
run 50-mcp.sh
run 60-indexers.sh
run 70-lsp.sh

printf '\nManual: in Codex run /hooks and trust the ponytail hooks. Restart Claude Code and Codex.\n'
[ -z "$failed" ] || { printf 'Failed:%s\n' "$failed"; exit 1; }
