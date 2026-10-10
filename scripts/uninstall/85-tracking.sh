#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
export DO_NOT_TRACK=1
npx -y "skills@$SKILLS_CLI" remove $(ls "$ROOT/skills-optional") -g -a claude-code -a codex -y
rm -f "${LAK_STATE_DIR:-$HOME/.leanagentkit}/tracking.conf"
