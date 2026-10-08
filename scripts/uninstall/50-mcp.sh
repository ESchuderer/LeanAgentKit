#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
for n in context7 playwright; do
  if have claude; then claude mcp remove --scope user "$n" || true; fi
  if have codex; then codex mcp remove "$n" || true; fi
done
