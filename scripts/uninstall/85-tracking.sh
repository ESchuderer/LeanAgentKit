#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
export DO_NOT_TRACK=1
del=""; for s in $(ls "$ROOT/skills-optional"); do kit_drop "$s"; done
[ -z "$del" ] || npx -y "skills@$SKILLS_CLI" remove $del -g -y
rm -f "${LAK_STATE_DIR:-$HOME/.leanagentkit}/tracking.conf"
