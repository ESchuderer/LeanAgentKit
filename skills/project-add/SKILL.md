---
name: project-add
description: "Add, change, or remove agent tooling in an already set-up repository: skills for a new dependency or capability, ECC extras, codegraph, OpenSpec, AGENTS.md commands, the ECC install route. Shows what is installed, asks what to change, then runs project-skills, project-codegraph, project-openspec, or project-instructions. Use when the user asks to enhance, extend, update, revalidate, clean up, or audit a project's agent setup, for example after the project grew."
---

# Project add

Run from the repository root. Changes stay inside the repository.

## 1. Inventory (read only)

Report one table:

- Instructions: `AGENTS.md`; `CLAUDE.md` imports `@AGENTS.md` or not; commands in `AGENTS.md` that no longer match the manifests.
- codegraph: `.codegraph/` present, `codegraph status`.
- OpenSpec: `openspec/` present, `openspec list`.
- Playwright MCP: `playwright` in `.mcp.json` and `.codex/config.toml`; a web UI in the stack or not.
- Verify hook: `.claude/hooks/verify.sh` and the `Stop` entries in `.claude/settings.json` and `.codex/hooks.json`; its command against the manifests.
- Skills: `npx skills ls` (skills CLI), `.claude/ecc/install-state.json` (ECC installer), directories in `.claude/skills/` or `.agents/skills/` that neither records (hand-copied), except `openspec-*` (OpenSpec).
- Stack against the `project-skills` table: rows detected but not installed, installed skills whose stack is gone, skills outside the table that the user did not name.
- Agents and rules: `.claude/agents/*.md`, `.claude/rules/**` (each loads every session). The kit installs none; list them for removal unless the user wants them.
- Full ECC installs: `ecc@ecc` in `claude plugin list`, `.claude/rules/ecc/`, a profile in the install-state. Report the skill and agent count.

## 2. Ask

If the user named the change, do only that. A plain update, refresh, or revalidate request: apply every stale item from the inventory without asking: skills (`project-skills`, "Update"), codegraph sync, `openspec update`, `AGENTS.md` commands, skills for stack rows detected but not installed; ask before removing skills whose stack is gone. Otherwise one multi-select question, options from the inventory:

- Add skills: stack gaps, or a capability the user names.
- ECC extras (`project-skills`, "ECC extras").
- Remove skills whose stack is gone; update installed skills.
- codegraph: set up, sync, remove.
- OpenSpec: set up, update, remove.
- Playwright MCP: set up, remove.
- Verify hook: set up, change the command, remove.
- `AGENTS.md`: refresh commands.
- Switch the ECC install route.
- Replace a full ECC install with single skills.

## 3. Apply

One plan, one confirmation, then the matching skill: `project-skills`, `project-codegraph`, `project-openspec`, `project-instructions`. Report changes and skipped steps; restart the agents when skills or MCP servers changed.
