#!/bin/sh
# codegraph CLI at the pinned version. Wire it per repository (README, "Per repository").
set -eu
. "$ROOT/scripts/lib.sh"
npm_g "@colbymchenry/codegraph@$CODEGRAPH"
codegraph telemetry off >/dev/null 2>&1 || true
