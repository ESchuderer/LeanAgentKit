#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
npx -y skills remove $(ls "$ROOT/skills") documentation-lookup unified-memory -g -a claude-code -a codex -y
