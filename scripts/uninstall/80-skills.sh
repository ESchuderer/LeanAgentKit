#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
npx -y skills remove $(ls "$ROOT/skills") documentation-lookup -g -a claude-code -a codex -y
