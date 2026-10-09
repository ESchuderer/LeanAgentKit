#!/bin/sh
# RTK: its own installer wires Claude Code (hook + RTK.md) and Codex (RTK.md only). Pinned on the curl path; winget and brew install the latest once.
set -eu
. "$ROOT/scripts/lib.sh"
got=$(rtk --version 2>/dev/null | awk '{print $2}' | tr -d '\r')
if win; then
  [ -n "$got" ] || winget install --id rtk-ai.rtk -e --accept-source-agreements --accept-package-agreements || true
  la=$(cygpath -u "$LOCALAPPDATA"); for d in "$la"/Microsoft/WinGet/Links "$la"/Microsoft/WinGet/Packages/rtk-ai.rtk*/; do PATH="$PATH:$d"; done
elif have brew; then
  [ -n "$got" ] || brew install rtk
elif [ "$got" != "${RTK#v}" ]; then
  curl -fsSL "https://raw.githubusercontent.com/rtk-ai/rtk/$RTK/install.sh" | RTK_VERSION=$RTK sh; PATH="$HOME/.local/bin:$PATH"  # verifies the release checksum
fi
rtk gain >/dev/null 2>&1 || { say "rtk missing or wrong package (rtk gain failed); open a new terminal and rerun"; exit 1; }
if cli claude; then rtk init -g --auto-patch --no-trust-filters; fi
if cli codex; then rtk init -g --codex; fi
rtk telemetry disable >/dev/null 2>&1 || true
