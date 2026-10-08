#!/bin/sh
# One shot: global rules, agent settings, tools. Delete a line below to skip that step.
# Windows: run from Git Bash. Needs git, node/npm, and the claude and codex CLIs on PATH.
set -u
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd); export ROOT
BACKUP_DIR="${LAK_STATE_DIR:-$HOME/.leanagentkit}/backups/$(date +%Y%m%d-%H%M%S)-install"; export BACKUP_DIR
. "$ROOT/scripts/lib.sh"
failed=""
# npm's global bin folder on PATH for every step and rerun. https://docs.npmjs.com/cli/v10/configuring-npm/folders
b=$(npm prefix -g 2>/dev/null | tr -d '\r')
if [ -n "$b" ]; then
  if win; then b=$(cygpath -u "$b"); else b=$b/bin; fi
  case ":$PATH:" in *":$b:"*) ;; *) PATH="$b:$PATH"; export PATH; say "npm bin folder not on PATH, add it: $b" ;; esac
fi
have codex || npm_g @openai/codex || failed="$failed codex"
run() { printf '\n== %s\n' "$1"; sh "$ROOT/scripts/install/$1" || failed="$failed $1"; }

run 10-rules.sh
run 20-settings.sh
run 30-rtk.sh
run 40-ponytail.sh
run 50-mcp.sh
run 60-indexers.sh
run 65-memory.sh
run 70-lsp.sh
run 80-skills.sh

printf '\n'
case "$failed" in *40-ponytail*) ;; *) if have codex; then say "Manual: in Codex run /hooks and trust the ponytail hooks."; fi ;; esac
say "Restart Claude Code and Codex."
[ -z "$failed" ] || { printf 'Failed:%s\n' "$failed"; exit 1; }
