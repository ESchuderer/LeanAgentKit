#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
for d in "$ROOT"/skills/*/; do n=$(basename "$d"); rm -rf "$CLAUDE_DIR/skills/$n" "$HOME/.agents/skills/$n"; done
say "skills: removed"
