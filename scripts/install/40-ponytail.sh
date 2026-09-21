#!/bin/sh
# Ponytail, the author's plugin install. Codex: trust its hooks once with /hooks afterwards.
set -eu
. "$ROOT/scripts/lib.sh"
if have claude && ! claude plugin list 2>/dev/null | grep -q ponytail; then
  claude plugin marketplace add DietrichGebert/ponytail || true
  claude plugin install ponytail@ponytail
fi
if have codex && ! codex plugin list 2>/dev/null | grep -q ponytail; then
  codex plugin marketplace add DietrichGebert/ponytail || true
  codex plugin add ponytail@ponytail
fi
say "ponytail: ok"
