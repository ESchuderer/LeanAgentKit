#!/bin/sh
# Ponytail from this repository's marketplace files, pinned by commit (.claude-plugin/marketplace.json, .agents/plugins/marketplace.json). Codex: trust its hooks once with /hooks afterwards.
set -eu
. "$ROOT/scripts/lib.sh"
sha=$(grep -o '[0-9a-f]\{40\}' "$ROOT/.claude-plugin/marketplace.json" | head -1)
root=$ROOT; win && root=$(cygpath -m "$ROOT")
if cli claude; then
  # kit before 2026-10: unpinned install from the author's marketplace; removing it uninstalls its plugin, its cache stays behind. Ponytail's own
  # state (level, mode flags) lives outside the plugin and is reused by the pinned install, so its scripts/uninstall.js is not run here.
  claude plugin marketplace remove ponytail >/dev/null 2>&1 || true
  rm -rf "$CLAUDE_DIR/plugins/cache/ponytail"
  claude plugin marketplace add "$root" >/dev/null 2>&1 || { claude plugin marketplace remove leanagentkit >/dev/null 2>&1 || true; claude plugin marketplace add "$root"; }  # registered from another path: the clone moved
  claude plugin marketplace update leanagentkit >/dev/null 2>&1 || true
  if ! grep -q "$sha" "$CLAUDE_DIR/plugins/installed_plugins.json" 2>/dev/null; then
    claude plugin uninstall ponytail@leanagentkit >/dev/null 2>&1 || true
    claude plugin install ponytail@leanagentkit
  fi
fi
if cli codex; then
  state=${LAK_STATE_DIR:-$HOME/.leanagentkit}/ponytail-codex.sha  # Codex keeps no record of the installed commit
  if codex plugin list 2>/dev/null | grep -q 'ponytail@ponytail'; then codex plugin remove ponytail@ponytail; fi  # same as above
  codex plugin marketplace add "$root" >/dev/null 2>&1 || { codex plugin marketplace remove leanagentkit >/dev/null 2>&1 || true; codex plugin marketplace add "$root"; }  # same
  if ! codex plugin list 2>/dev/null | grep -Eq '^ponytail@leanagentkit +installed' || [ "$(cat "$state" 2>/dev/null)" != "$sha" ]; then
    codex plugin remove ponytail@leanagentkit >/dev/null 2>&1 || true
    codex plugin add ponytail@leanagentkit
    mkdir -p "${state%/*}"; printf '%s\n' "$sha" > "$state"
  fi
fi
say "ponytail: ok"
