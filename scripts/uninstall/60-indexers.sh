#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
have codegraph && npm uninstall -g @colbymchenry/codegraph
have uv && { uv tool uninstall serena-agent || true; }
say "uv itself stays; remove with: uv self uninstall"
