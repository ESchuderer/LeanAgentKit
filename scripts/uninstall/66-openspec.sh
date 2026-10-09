#!/bin/sh
set -eu
. "$ROOT/scripts/lib.sh"
npm uninstall -g @fission-ai/openspec
say "repo files stay: openspec/, .claude/skills/openspec-*, .agents/skills/openspec-*"
