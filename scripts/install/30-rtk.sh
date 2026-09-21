#!/bin/sh
# RTK: its own installer wires Claude Code (hook + RTK.md) and Codex (RTK.md only).
set -eu
. "$ROOT/scripts/lib.sh"
if ! have rtk; then
  if win; then winget install --id rtk-ai.rtk -e --accept-source-agreements --accept-package-agreements || true
    la=$(cygpath -u "$LOCALAPPDATA"); for d in "$la"/Microsoft/WinGet/Links "$la"/Microsoft/WinGet/Packages/rtk-ai.rtk*/; do PATH="$PATH:$d"; done
  elif have brew; then brew install rtk
  else curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh; PATH="$HOME/.local/bin:$PATH"
  fi
fi
rtk gain >/dev/null 2>&1 || { say "rtk missing or wrong package (rtk gain failed); open a new terminal and rerun"; exit 1; }
have claude && rtk init -g --auto-patch --no-trust-filters
have codex && rtk init -g --codex
rtk telemetry disable >/dev/null 2>&1 || true
