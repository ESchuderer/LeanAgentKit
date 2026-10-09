---
name: project-openspec
description: "Set up, update, or remove OpenSpec spec-driven development in one repository for Claude Code and Codex: changes start as a proposal with tasks and spec deltas and are archived into openspec/specs/. Use when the user asks for OpenSpec, specs before code, or change proposals in a project."
---

# Project OpenSpec

Run by `project-setup` or `project-add`: use their answers, ask only what is missing. Behavior below verified on OpenSpec 1.14.1 (`openspec --version`). https://github.com/Fission-AI/OpenSpec

CLI: `scripts/install/66-openspec.sh` in LeanAgentKit (pinned version, telemetry off, delivery `skills`), otherwise `npm i -g @fission-ai/openspec@1.14.1 && openspec config set telemetry.enabled false`. The OpenSpec skills call it, so it must stay on PATH.

## Set up

```sh
openspec init --tools claude,codex --no-animation
```

Writes:

- `openspec/config.yaml`, `openspec/specs/`, `openspec/changes/archive/`: commit them.
- Skills `openspec-propose`, `-explore`, `-apply-change`, `-update-change`, `-sync-specs`, `-archive-change` in `.claude/skills/` (Claude Code) and `.agents/skills/` (Codex). With delivery `both`, also `/opsx:*` commands in `.claude/commands/opsx/`.
- `AGENTS.md` and `CLAUDE.md` stay unchanged.

Tell the user how to start: Claude Code `/openspec-propose <idea>`, Codex `$openspec-propose <idea>`; `openspec-explore` to think it through first. Existing code: https://github.com/Fission-AI/OpenSpec/blob/main/docs/existing-projects.md

## Update

After a CLI upgrade or a profile or delivery change: `openspec update`. It rewrites the generated skills.

## Remove

No remove command. Ask first: `openspec/` holds the project's specs and change history.

- Delete `openspec/`, `.claude/skills/openspec-*`, `.claude/commands/opsx/`, `.agents/skills/openspec-*`, `.agents/skills/.openspec-target`.
