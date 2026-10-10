#!/bin/sh
# After install: context cost of the global skills (name and description load every session), then a scan of every third-party skill and plugin for malicious content.
set -eu
. "$ROOT/scripts/lib.sh"
desc() { awk '/^---$/ { if (++n == 2) exit; next } n == 1 && /^description:/ { d = 1; print; next } d && /^[^ \t]/ { exit } d { print }' "$1" | wc -c; }
for f in "$SKILLS_DIR"/*/SKILL.md "$CLAUDE_DIR"/plugins/cache/*/*/*/skills/*/SKILL.md; do
  [ -f "$f" ] && printf '%6d %s\n' "$(desc "$f")" "${f#"$HOME"/}"
done | sort -rn | awk '{ t += $1; print } END { printf "%6d bytes of skill descriptions in context each session\n", t }'
have uvx || { say "skill scan skipped: needs uv, https://docs.astral.sh/uv/"; exit 0; }
rc=0
for d in "$SKILLS_DIR" "$CLAUDE_DIR/plugins/cache" "$CODEX_DIR/plugins/cache"; do
  [ -d "$d" ] || continue
  uvx --from "cisco-ai-skill-scanner==$SKILL_SCANNER" skill-scanner scan-all "$d" --recursive --format summary --fail-on-findings || { rc=1; say "findings in $d: read the flagged SKILL.md and scripts before keeping them"; }
done
exit "$rc"
