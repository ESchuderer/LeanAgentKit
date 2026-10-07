#!/bin/sh
# Agent settings. Adds keys that are absent; never changes an existing value.
set -eu
. "$ROOT/scripts/lib.sh"

f=$CLAUDE_DIR/settings.json
[ -f "$f" ] || printf '{}\n' > "$f"
backup "$f"
sl=$CLAUDE_DIR/leanagentkit-statusline.js
cp "$ROOT/scripts/statusline.js" "$sl"
win && sl=$(cygpath -m "$sl")  # status line commands need forward slashes on Windows
node - "$f" "$sl" <<'NODE'
const fs = require("fs"); const [f, sl] = process.argv.slice(2);
const s = JSON.parse(fs.readFileSync(f, "utf8").replace(/^﻿/, "") || "{}");
s.model ??= "sonnet";
s.env ??= {};
s.env.DISABLE_ERROR_REPORTING ??= "1";
s.env.CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY ??= "1";
s.remoteControlAtStartup ??= true;
s.advisorModel ??= "opus";
s.showClearContextOnPlanAccept ??= true;
s.statusLine ??= { type: "command", command: `node "${sl}"` };
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
