---
name: project-setup
description: "First-time agent setup of a new or existing repository for Claude Code and Codex. Asks how to install ECC skills, whether to index with codegraph, whether to use OpenSpec, and whether to add the verify hook, then runs project-instructions, project-codegraph, project-openspec, and project-skills. Use when the user asks to start, set up, bootstrap, or onboard a project. Later changes: project-add."
---

# Project setup

Run from the repository root. Changes stay inside the repository.

## 1. Detect (read only)

- Mode: **new** if there is no dependency manifest and no source file, or the user says new project; otherwise **existing**.
- Already set up (`AGENTS.md` plus any of `.codegraph/`, `skills-lock.json`, `.claude/ecc/install-state.json`): use the `project-add` skill instead.
- Stack: `project-skills`, section "Detect".

## 2. Ask first

One message (Claude Code: AskUserQuestion), recommended option first:

1. **ECC install route**
   - Skills CLI (recommended): `npx skills`, one skill at a time, Claude Code and Codex, `skills-lock.json`; same tool for non-ECC skills.
   - ECC installer, per skill: `ecc-universal install --skills` for Claude Code; adds ECC `doctor`, `repair`, `uninstall`, and installer-only extras. Codex and module-bound skills still use the skills CLI.
2. **codegraph index**: yes (recommended when there is code), no.
3. **OpenSpec**: yes (changes start as a proposal with tasks and spec deltas, then are archived into `openspec/specs/`), no (plan mode only; small or short-lived repos).
4. **Verify hook**: yes (the check command runs when the agent stops and blocks "done" while it fails; one run per turn with changes), no (recommended for a slow suite; `verification-loop` stays).

New project, second message, at most four questions:

1. What it is: web app, API, CLI, library, mobile app; one sentence on its purpose.
2. Language and framework: rows of the `project-skills` table, or "recommend".
3. Data: none, PostgreSQL, MySQL, SQLite, Redis; ORM if any.
4. Extras: Playwright end-to-end tests, Docker.

## 3. Plan, apply, report

- New project: scaffold with the framework's official generator, command looked up with Context7 (`documentation-lookup`), not recalled; `git init` if there is no repository.
- One plan: files to create or change, commands, skills with one line each. Apply after one confirmation, in this order:
  1. `project-instructions`, with the verify hook if chosen
  2. `project-codegraph`, if chosen
  3. `project-openspec`, if chosen
  4. `project-skills`, with the chosen route
- Report changes, installed skills, and skipped steps with the reason. Restart the agents to load skills and MCP servers.
