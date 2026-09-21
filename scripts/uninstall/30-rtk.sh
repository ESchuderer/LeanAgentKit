#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
have rtk || exit 0
have claude && rtk init -g --uninstall
have codex && rtk init -g --codex --uninstall
if win; then winget uninstall --id rtk-ai.rtk -e || true
elif have brew && brew list rtk >/dev/null 2>&1; then brew uninstall rtk
else rm -f "$HOME/.local/bin/rtk"; fi
