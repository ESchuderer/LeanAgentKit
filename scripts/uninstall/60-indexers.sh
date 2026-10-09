#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
if have codegraph; then npm uninstall -g @colbymchenry/codegraph; fi
