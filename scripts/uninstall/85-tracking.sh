#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
export DO_NOT_TRACK=1
del=""; for s in $(ls "$ROOT/skills-optional"); do  # only skills installed from this kit (skills CLI lock); a same-name skill from another source stays
  [ -e "$SKILLS_DIR/$s" ] || continue; if kit_skill "$s"; then del="$del $s"; else say "$s: not installed from this kit, kept"; fi
done
[ -z "$del" ] || npx -y "skills@$SKILLS_CLI" remove $del -g -a claude-code -a codex -y
rm -f "${LAK_STATE_DIR:-$HOME/.leanagentkit}/tracking.conf"
