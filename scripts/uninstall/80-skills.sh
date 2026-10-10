#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
npx -y "skills@$SKILLS_CLI" remove $(ls "$ROOT/skills") documentation-lookup unified-memory -g -y
