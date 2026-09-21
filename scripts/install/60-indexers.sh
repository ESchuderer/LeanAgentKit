#!/bin/sh
# codegraph and Serena CLIs. Wire exactly one per repository (README, "Per repository").
set -eu
. "$ROOT/scripts/lib.sh"
have codegraph || npm i -g @colbymchenry/codegraph
codegraph telemetry off >/dev/null 2>&1 || true
if ! have uv; then
  if win; then powershell -NoProfile -Command "irm https://astral.sh/uv/install.ps1 | iex"
  else curl -LsSf https://astral.sh/uv/install.sh | sh; fi
  PATH="$HOME/.local/bin:$PATH"
fi
have serena || { say "serena: uv downloads Python 3.13"; uv tool install -p 3.13 serena-agent; }
