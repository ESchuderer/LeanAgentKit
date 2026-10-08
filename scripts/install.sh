#!/bin/sh
# One shot: global rules, agent settings, tools. Delete a line below to skip that step.
# Windows: run from Git Bash. Needs git, node/npm, and the claude and codex CLIs on PATH.
set -u
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd); export ROOT
BACKUP_DIR="${LAK_STATE_DIR:-$HOME/.leanagentkit}/backups/$(date +%Y%m%d-%H%M%S)-install"; export BACKUP_DIR
. "$ROOT/scripts/lib.sh"
failed=""

# Steps run `npm i -g` (codex, codegraph, ecc-universal, language servers) without sudo.
d=$(npm root -g); win && d=$(cygpath -u "$d")
while [ ! -e "$d" ]; do d=$(dirname -- "$d"); done
if [ ! -w "$d" ]; then
  say "npm global folder not writable: $(npm root -g)"
  say "Fix: npm config set prefix ~/.local, put ~/.local/bin on PATH, rerun. https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally"
  exit 1
fi
have codex || npm i -g @openai/codex
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

printf '\nManual: in Codex run /hooks and trust the ponytail hooks. Restart Claude Code and Codex.\n'
# Steps 30, 40, 50, 70 configure an agent only through its CLI; the VS Code extensions do not put it on PATH.
have claude || { say "claude CLI not on PATH: RTK hooks, Ponytail, MCP servers, LSP plugins skipped for Claude Code. Install: https://code.claude.com/docs/en/setup"; failed="$failed claude"; }
have codex || { say "codex CLI not on PATH: RTK hooks, Ponytail, MCP servers skipped for Codex. Install: npm i -g @openai/codex"; failed="$failed codex"; }
[ -z "$failed" ] || { printf 'Failed:%s\n' "$failed"; exit 1; }
