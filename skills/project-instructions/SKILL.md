---
name: project-instructions
description: "Create, merge, or refresh a repository's agent instructions: AGENTS.md with the project's real commands, CLAUDE.md containing only @AGENTS.md, so Claude Code and Codex read one file. Use when AGENTS.md or CLAUDE.md is missing, duplicated, or out of date."
---

# Project instructions

Run by `project-setup` or `project-add`: use their answers, ask only what is missing.

- One file for both agents: instructions in `AGENTS.md`, `CLAUDE.md` contains only `@AGENTS.md`. https://code.claude.com/docs/en/memory
- Next.js 16.3+: `next dev` generates both files; leave them. https://nextjs.org/docs/app/guides/ai-agents

## Create

`AGENTS.md`:

- Purpose: one sentence (new project: from `project-setup`).
- Commands that exist in the manifests and scripts: install, run, build, test (all and a single test), lint, format, type check.
- Repository facts an agent cannot guess: required environment variables (names from `.env.example`, never values), generated files not to edit, monorepo layout.

Leave out style rules and generic advice (global rules cover them) and codegraph text (codegraph writes its own block).

## Existing files

- Only `CLAUDE.md` has content: move it to `AGENTS.md`, set `CLAUDE.md` to `@AGENTS.md`.
- Both have content: show the difference, ask how to merge.
- Refresh: compare the commands with the manifests and propose only command changes. Keep everything else, including marker-fenced blocks such as `<!-- CODEGRAPH_START -->`.
- Monorepo package with its own commands: its own `AGENTS.md` and `CLAUDE.md`, same rules.

## Verify hook (when chosen)

The one enforced SDLC step: rules are context, hooks run. Both agents run `.claude/hooks/verify.sh` when the agent stops; exit 2 with the failing output on stderr continues the turn with that reason. https://code.claude.com/docs/en/hooks https://learn.chatgpt.com/docs/hooks

`.claude/hooks/verify.sh`, with the repository's own check command (the test command; lint and type check instead for a slow suite):

```sh
#!/bin/sh
# Stop hook: blocks "done" while the checks fail. Exit 2 + stderr = continue with the reason (Claude Code and Codex).
case $(cat) in *'"stop_hook_active": true'*|*'"stop_hook_active":true'*) exit 0 ;; esac  # already continuing from this hook
[ -n "$(git status --porcelain 2>/dev/null)" ] || exit 0  # shortcut: clean tree, nothing to check; upgrade to a commit-range check when commits land before the stop
log=$(mktemp); trap 'rm -f "$log"' EXIT
<check command> >"$log" 2>&1 && exit 0
tail -40 "$log" >&2; exit 2
```

`.claude/settings.json`, merged into existing keys:

```json
{ "hooks": { "Stop": [ { "hooks": [ { "type": "command", "command": "sh \"$CLAUDE_PROJECT_DIR\"/.claude/hooks/verify.sh", "timeout": 600 } ] } ] } }
```

`.codex/hooks.json`, loaded in trusted projects; the user trusts it once with `/hooks`:

```json
{ "hooks": { "Stop": [ { "hooks": [ { "type": "command", "command": "sh \"$(git rev-parse --show-toplevel)/.claude/hooks/verify.sh\"", "timeout": 600 } ] } ] } }
```

Claude Code ends the turn after eight blocked stops in a row. Remove: delete the script and both `Stop` entries.
