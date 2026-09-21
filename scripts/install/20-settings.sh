#!/bin/sh
# Agent settings. Adds keys that are absent; never changes an existing value.
set -eu
. "$ROOT/scripts/lib.sh"

f=$CLAUDE_DIR/settings.json
[ -f "$f" ] || printf '{}\n' > "$f"
backup "$f"
node - "$f" <<'NODE'
const fs = require("fs"); const f = process.argv[2];
const s = JSON.parse(fs.readFileSync(f, "utf8").replace(/^﻿/, "") || "{}");
s.model ??= "sonnet";
s.env ??= {};
s.env.DISABLE_ERROR_REPORTING ??= "1";
s.env.CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY ??= "1";
s.env.SERENA_USAGE_REPORTING ??= "false";
s.remoteControlAtStartup ??= true;
fs.writeFileSync(f, JSON.stringify(s, null, 2) + "\n");
NODE
say "claude settings: ok"

f=$CODEX_DIR/config.toml
[ -f "$f" ] || : > "$f"
backup "$f"
add() {  # add "key = value" before the first [table] unless the key exists
  grep -Eq "^[[:space:]]*$1[[:space:]]*=" "$f" && return 0
  awk -v l="$2  # leanagentkit" '/^[[:space:]]*\[/ && !d { print l; d = 1 } { print } END { if (!d) print l }' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
}
add model_reasoning_effort 'model_reasoning_effort = "medium"'
add plan_mode_reasoning_effort 'plan_mode_reasoning_effort = "high"'
grep -Eq '^\[analytics\]' "$f" || add 'analytics\.enabled' 'analytics.enabled = false'
say "codex config: ok"
