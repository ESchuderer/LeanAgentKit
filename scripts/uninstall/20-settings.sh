#!/bin/sh
# Removes only the keys the installer adds, and only if they still hold the installer's values.
set -eu
. "$ROOT/scripts/lib.sh"
f=$CLAUDE_DIR/settings.json
if [ -f "$f" ]; then
  backup "$f"
  node - "$f" <<'NODE'
const fs = require("fs"); const f = process.argv[2];
const s = JSON.parse(fs.readFileSync(f, "utf8").replace(/^﻿/, ""));
if (s.model === "sonnet") delete s.model;
if (s.remoteControlAtStartup === true) delete s.remoteControlAtStartup;
for (const [k, v] of [["DISABLE_ERROR_REPORTING", "1"], ["CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY", "1"], ["SERENA_USAGE_REPORTING", "false"]])
  if (s.env && s.env[k] === v) delete s.env[k];
if (s.env && !Object.keys(s.env).length) delete s.env;
fs.writeFileSync(f, JSON.stringify(s, null, 2) + "\n");
NODE
fi
f=$CODEX_DIR/config.toml
if [ -f "$f" ]; then backup "$f"; { grep -v '# leanagentkit$' "$f" || true; } > "$f.tmp"; mv "$f.tmp" "$f"; fi
say "settings: removed"
