#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
for n in context7 playwright; do
  have claude && { claude mcp remove --scope user "$n" || true; }
  have codex && { codex mcp remove "$n" || true; }
done
