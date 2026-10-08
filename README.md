# LeanAgentKit

The lean architecture for AI coding. Global constraints optimized for pure execution.

## Install

```sh
sh scripts/install.sh      # Windows: from Git Bash. Needs git, node, and the claude and codex CLIs.
sh scripts/uninstall.sh
```

One file per step in `scripts/install/` and `scripts/uninstall/`; delete a line in `scripts/install.sh` to skip a step. Each step calls the tool's own installer. Steps: rules, settings, RTK, Ponytail, MCP servers (Context7, Playwright), codegraph CLI, ECC Memory Vault CLI, LSP plugins, skills (`project-*` from `skills/`, ECC `documentation-lookup` and `unified-memory`). Edited files are backed up to `~/.leanagentkit/backups/`.

After the run: in Codex run `/hooks` and trust the Ponytail hooks; restart both agents.

## Global rules

[rules/global.md](rules/global.md). Project instructions override it.

- Claude Code: `~/.claude/rules/00-leanagentkit-global.md`, loaded every session before project rules. https://code.claude.com/docs/en/memory
- Codex: marked block at the top of `~/.codex/AGENTS.md`. https://learn.chatgpt.com/docs/agent-configuration/agents-md

## Tools

- RTK: filters shell output before it reaches the model. Bash tool only. https://github.com/rtk-ai/rtk
- Ponytail: makes the agent write the minimal code that works (YAGNI, standard library first). https://github.com/DietrichGebert/ponytail
- Context7 MCP: current library docs on demand; the ECC `documentation-lookup` skill calls it for library and API questions. Free API key for higher limits: export `CONTEXT7_API_KEY` before installing. https://github.com/upstash/context7
- Playwright MCP: the agent drives a browser to verify UI changes. In a container: headless Chrome, installed by the script. https://github.com/microsoft/playwright-mcp
- codegraph: repository graph over MCP, one query instead of many file reads. Per repository. https://github.com/colbymchenry/codegraph
- ECC Memory Vault: `ecc memory save`, `handoff`, `search` pass work state between Claude Code and Codex as Markdown files in `<repo>/.ecc/memory/project/` (git-ignored) and `team/` (versioned); `~/.ecc/memory/` only with `--scope user`. The `unified-memory` skill tells both agents when to use it. CLI only; the optional MCP server (`ecc-memory-mcp`) is not registered. Package `ecc-universal`: 19.5 MB, 2805 files, no install scripts. https://github.com/affaan-m/ECC/blob/main/skills/unified-memory/SKILL.md
- Code intelligence plugins (Claude Code): `typescript-lsp`, `pyright-lsp`. Diagnostics after every edit, go to definition, find references. https://code.claude.com/docs/en/discover-plugins

## Per repository

Skills in [skills/](skills/), installed globally by the script. Claude Code: `/<name>`, Codex: `$<name>`. Each shows one plan and applies it after one confirmation.

| Skill | Does |
|---|---|
| `project-setup` | first setup of a new or existing repository. Asks first: ECC install route, codegraph or not; new project also type, stack, data, extras, then scaffolds with the framework's generator |
| `project-add` | later changes: shows what is installed, then adds, updates, or removes skills, ECC extras, codegraph, `AGENTS.md` commands |
| `project-instructions` | `AGENTS.md` with the project's commands, `CLAUDE.md` containing `@AGENTS.md`. Next.js 16.3+ generates both on `next dev`. https://nextjs.org/docs/app/guides/ai-agents |
| `project-codegraph` | codegraph index and MCP wiring for both agents: set up, sync, remove |
| `project-skills` | skills for the detected stack, project scope: ECC base (`tdd-workflow`, `verification-loop`) plus the matching ones |

`project-setup` and `project-add` run the other three.

## ECC

Everything Claude Code: 293 skills, 69 agents, rules, hooks; Claude Code and Codex. https://github.com/affaan-m/ECC

Every installed skill and agent puts its name and description in context each session; ECC's skill descriptions total about 100 KB (roughly 25k tokens).

| Route (ECC 2.2.3, project target, no hooks) | Footprint | Used |
|---|---|---|
| `ecc@ecc` plugin | all skills (Codex plugin: 281) and hooks | no |
| `install --profile minimal` / `full` | 489 / 978 files; `minimal` includes 69 agents and 122 rule files | no |
| `install --skills <id>` | one skill per ID; 15 IDs pull a whole module (`tdd-workflow`: 113 files) | `project-skills`, ECC installer route (Claude Code) |
| `npx skills add affaan-m/ECC -s <id>` | one skill per ID, both agents | `project-skills`, default route |

- Installer route: adds `ecc doctor`, `repair`, `uninstall`; sets `"includeCoAuthoredBy": false` in `.claude/settings.json` when no attribution setting exists. Its Codex target writes to `~/.codex` only, so Codex gets project skills through the skills CLI.
- ECC context profiles (`ecc profile`, `lean@1`): read-only preview in 2.2.3.
- Hermes, ECC's operator shell for chat, cron, content, and business workflows: not used. https://github.com/affaan-m/ECC/blob/main/docs/HERMES-SETUP.md
- List: `npx skills add affaan-m/ECC --list`.

## Dev containers (VS Code)

Agents and tools run in a Linux container; the repo is bind-mounted. https://code.claude.com/docs/en/devcontainer

1. Docker:
   - CachyOS/Arch: `sudo pacman -S docker docker-buildx && sudo systemctl enable --now docker && sudo usermod -aG docker $USER`, then log out and in. https://wiki.archlinux.org/title/Docker
   - Windows: `winget install Docker.DockerDesktop` (WSL 2 backend); keep repos in the WSL filesystem. https://code.visualstudio.com/docs/devcontainers/containers#_installation
2. `code --install-extension ms-vscode-remote.remote-containers`
3. VS Code user `settings.json`, applied to every dev container: adds Claude Code, clones this repo, runs `scripts/install.sh` (installs Codex if missing). https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories

   ```json
   "dev.containers.defaultFeatures": { "ghcr.io/anthropics/devcontainer-features/claude-code:1.0": {} },
   "dotfiles.repository": "ESchuderer/LeanAgentKit",
   "dotfiles.installCommand": "scripts/install.sh"
   ```

4. Repo without `.devcontainer/`: `Dev Containers: Add Dev Container Configuration Files`, any template. Then `Dev Containers: Reopen in Container`.
5. Sign in per container: `claude`, `codex login --device-auth`. Rebuilds drop the login.

## Skills

[SKILLS.md](SKILLS.md): install commands and the list.

## Config

Claude Code, `~/.claude/settings.json` (https://code.claude.com/docs/en/settings):

```json
{
  "model": "sonnet",
  "env": { "DISABLE_ERROR_REPORTING": "1", "CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY": "1" },
  "remoteControlAtStartup": true,
  "advisorModel": "opus",
  "showClearContextOnPlanAccept": true,
  "statusLine": { "type": "command", "command": "node \"<home>/.claude/leanagentkit-statusline.js\"" }
}
```

- `advisorModel`: a stronger model advises at decision points (plans, recurring errors, before declaring done) while `sonnet` does the typing; Claude decides when. Not attached when the main model ranks above it (Fable). Its tokens count toward the plan. https://code.claude.com/docs/en/advisor
- `showClearContextOnPlanAccept`: approving a plan offers to clear the context before execution.
- `statusLine`: [scripts/statusline.js](scripts/statusline.js), for example `Sonnet (medium) | ctx 23% | 5h 24% until 14:00 | week 41%`. Plan limits appear on Pro and Max. No token cost. https://code.claude.com/docs/en/statusline

Codex, `~/.codex/config.toml` (https://learn.chatgpt.com/docs/config-file/config-reference):

```toml
model_reasoning_effort = "medium"
plan_mode_reasoning_effort = "high"
analytics.enabled = false
```

## Tips

- Plan mode before non-trivial changes: `Shift+Tab` until `plan mode on`, or `claude --permission-mode plan`. Reads and proposes, edits nothing until approved. https://code.claude.com/docs/en/common-workflows
- Global rules: the agent suggests `/clear` when a prompt starts an unrelated task, and reviews code commits before it pushes or opens a pull request. `/simplify` (over-engineering, reuse) and `/security-review` are present in Claude Code 2.1.269. https://code.claude.com/docs/en/skills
- `/model opusplan`: Opus in plan mode, Sonnet for execution. `/effort` per task: low for routine edits, high for hard debugging. https://code.claude.com/docs/en/model-config
- Never set `DISABLE_TELEMETRY`, `DO_NOT_TRACK`, `DISABLE_GROWTHBOOK`, or `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`: each turns off the advisor and Remote Control. https://code.claude.com/docs/en/env-vars
- One project file for both agents: instructions in `AGENTS.md`, `CLAUDE.md` containing only `@AGENTS.md`. https://code.claude.com/docs/en/memory
- Auto memory: corrections you give persist per project in `~/.claude/projects/<project>/memory/`. Same source.
- `/fewer-permission-prompts` writes an allowlist of read-only commands to the project settings (bundled in Claude Code 2.1.269).
- Codex: leave `service_tier` unset; `"fast"` costs 2.5x credits on GPT-6 Astra. https://learn.chatgpt.com/docs/agent-configuration/speed
- Codex: plugin hooks must be trusted in `/hooks` again after every plugin update. https://learn.chatgpt.com/docs/hooks
- Plan usage: status line and `/usage` in Claude Code, `/status` in Codex. From local logs: `npx ccusage@latest` (https://github.com/ccusage/ccusage).
- A console window per prompt or tool call on Windows is a hook: `hooks` in `~/.claude/settings.json`, plugin hooks (Ponytail has three), `~/.codex/hooks.json`.
