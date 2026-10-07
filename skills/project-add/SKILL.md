---
name: project-add
description: "Add, change, or remove agent tooling in an already set-up repository: skills for a new dependency or capability, ECC extras, codegraph, AGENTS.md commands, the ECC install route. Shows what is installed, asks what to change, then runs project-skills, project-codegraph, or project-instructions. Use when the user asks to enhance, extend, update, clean up, or audit a project's agent setup."
---

# Project add

Run from the repository root. Changes stay inside the repository.

## 1. Inventory (read only)

Report one table:

- Instructions: `AGENTS.md`; `CLAUDE.md` imports `@AGENTS.md` or not; commands in `AGENTS.md` that no longer match the manifests.
- codegraph: `.codegraph/` present, `codegraph status`.
- Skills: `npx skills ls` (skills CLI), `.claude/ecc/install-state.json` (ECC installer), directories in `.claude/skills/` or `.agents/skills/` that neither records (hand-copied).
- Stack against the `project-skills` table: rows detected but not installed, installed skills whose stack is gone.
- Full ECC installs: `ecc@ecc` in `claude plugin list`, `.claude/rules/ecc/`, a profile in the install-state. Report the skill and agent count.

## 2. Ask

If the user named the change, do only that. Otherwise one multi-select question, options from the inventory:

- Add skills: stack gaps, or a capability the user names.
- ECC extras (`project-skills`, "ECC extras").
- Remove skills whose stack is gone; update installed skills.
- codegraph: set up, sync, remove.
- `AGENTS.md`: refresh commands.
- Switch the ECC install route.
- Replace a full ECC install with single skills.

## 3. Apply

One plan, one confirmation, then the matching skill: `project-skills`, `project-codegraph`, `project-instructions`. Report changes and skipped steps; restart the agents when skills or MCP servers changed.
