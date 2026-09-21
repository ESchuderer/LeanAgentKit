#!/bin/sh
# Reverses scripts/install.sh step by step with each tool's own uninstall command.
set -u
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd); export ROOT
BACKUP_DIR="${LAK_STATE_DIR:-$HOME/.leanagentkit}/backups/$(date +%Y%m%d-%H%M%S)-uninstall"; export BACKUP_DIR
failed=""
run() { printf '\n== %s\n' "$1"; sh "$ROOT/scripts/uninstall/$1" || failed="$failed $1"; }

run 70-lsp.sh
run 60-indexers.sh
run 50-mcp.sh
run 40-ponytail.sh
run 30-rtk.sh
run 20-settings.sh
run 10-rules.sh

printf '\nRestart Claude Code and Codex. Backups: %s\n' "${LAK_STATE_DIR:-$HOME/.leanagentkit}/backups"
[ -z "$failed" ] || { printf 'Failed:%s\n' "$failed"; exit 1; }
