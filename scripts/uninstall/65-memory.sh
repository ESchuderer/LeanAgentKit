#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
npm uninstall -g ecc-universal
say "memory vaults stay: .ecc/memory/ in each repo, ~/.ecc/memory/"
