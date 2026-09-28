#!/bin/sh
# codegraph CLI. Wire it per repository (README, "Per repository").
set -eu
. "$ROOT/scripts/lib.sh"
have codegraph || npm i -g @colbymchenry/codegraph
codegraph telemetry off >/dev/null 2>&1 || true
