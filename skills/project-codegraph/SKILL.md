---
name: project-codegraph
description: "Set up, check, sync, or remove the codegraph code index for one repository, wired into Claude Code and Codex at project level. Use when the user asks for codegraph, a code graph or index of the repository, or to remove it."
---

# Project codegraph

Run by `project-setup` or `project-add`: use their answers, ask only what is missing. Behavior below verified on codegraph 1.6.2 (`codegraph --version`). https://github.com/colbymchenry/codegraph

CLI: installed by LeanAgentKit (`scripts/install/60-indexers.sh`), otherwise `npm i -g @colbymchenry/codegraph`.

## Set up

Needs source code. Create `AGENTS.md` first (`project-instructions`) so the instruction block lands in it.

```sh
codegraph install --target=claude,codex --location=local --no-permissions --yes --init
```

Writes:

- `.codegraph/`: the index, ignored by its own `.gitignore`.
- `.mcp.json` and `.codex/config.toml`: MCP server `codegraph serve --mcp`. Codex loads project config only in trusted projects.
- `.claude/settings.json`: `UserPromptSubmit` hook `codegraph prompt-hook`.
- Block between `<!-- CODEGRAPH_START -->` and `<!-- CODEGRAPH_END -->` in `AGENTS.md` and `.claude/CLAUDE.md`.

Then: `CLAUDE.md` imports `@AGENTS.md`, so delete `.claude/CLAUDE.md` if it holds only that block (`codegraph upgrade` writes it again). Write no codegraph guidance yourself.

## Check and sync

- `codegraph status`: index statistics.
- Auto-sync keeps the index current; `codegraph sync` updates it by hand, `codegraph index` rebuilds it.

## Remove (this repository only)

```sh
codegraph uninstall --target=claude,codex --location=local --keep-cli --yes && codegraph uninit --force
```

Then delete `.mcp.json` and `.claude/settings.json` if they are now `{}`.

## Share

Commit `.mcp.json`, `.codex/config.toml`, `.claude/settings.json`, and the `AGENTS.md` block to share the wiring. Each clone needs the CLI and builds its own index: `codegraph init`.
