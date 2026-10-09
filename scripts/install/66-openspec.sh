#!/bin/sh
# OpenSpec CLI at the pinned version: spec-driven changes per repository; wire a repo with the project-openspec skill. Its skills call this CLI.
set -eu
. "$ROOT/scripts/lib.sh"
npm_g "@fission-ai/openspec@$OPENSPEC"
# skills only, unless chosen: delivery "both" gives Claude Code every workflow twice (skill and /opsx command).
# Checked first: any `config set` marks delivery explicit.
openspec config list 2>/dev/null | grep -q 'delivery: .*(explicit)' || openspec config set delivery skills >/dev/null
openspec config set telemetry.enabled false >/dev/null
say "openspec: ok"
