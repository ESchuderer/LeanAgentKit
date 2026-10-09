#!/bin/sh
# One shot: global rules, agent settings, tools. Profiles: core (default) or full; or step names to run only those.
# Inside a container Codex is installed when missing: the dotfiles flow passes no arguments and the Claude Code feature ships no Codex.
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
core="10-rules.sh 20-settings.sh 30-rtk.sh 40-ponytail.sh 50-mcp.sh 80-skills.sh 90-check.sh"
full="10-rules.sh 20-settings.sh 30-rtk.sh 40-ponytail.sh 50-mcp.sh 60-indexers.sh 65-memory.sh 66-openspec.sh 70-lsp.sh 80-skills.sh 90-check.sh"
profile=${1:-core}
case $profile in core) steps=$core ;; full) steps=$full ;; *) steps=$* ;; esac
if [ "$profile" = full ] || [ -f /.dockerenv ] || [ -f /run/.containerenv ]; then have codex || npm_g @openai/codex || failed="$failed codex"; fi
run() { printf '\n== %s\n' "$1"; sh "$ROOT/scripts/install/$1" || failed="$failed $1"; }
for s in $steps; do run "$s"; done

printf '\n'
case " $steps " in *" 40-ponytail.sh "*) case "$failed" in *40-ponytail*) ;; *) have codex && say "Manual: in Codex run /hooks and trust the ponytail hooks." ;; esac ;; esac
say "Restart Claude Code and Codex."
[ -z "$failed" ] || { printf 'Failed:%s\n' "$failed"; exit 1; }
