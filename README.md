# LeanAgentKit

The lean architecture for AI coding. Global constraints optimized for pure execution.

## Install

```sh
sh scripts/install.sh      # Windows: from Git Bash. Needs git, node, and the claude and codex CLIs.
sh scripts/uninstall.sh
```

One file per step in `scripts/install/` and `scripts/uninstall/`; delete a line in `scripts/install.sh` to skip a step. Each step calls the tool's own installer. Steps: rules, settings, RTK, Ponytail, MCP servers (Context7, Playwright), codegraph CLI, LSP plugins, skills. Edited files are backed up to `~/.leanagentkit/backups/`.

After the run: in Codex run `/hooks` and trust the Ponytail hooks; restart both agents.

## Global rules

[rules/global.md](rules/global.md). Project instructions override it.

- Claude Code: `~/.claude/rules/00-leanagentkit-global.md`, loaded every session before project rules. https://code.claude.com/docs/en/memory
- Codex: marked block at the top of `~/.codex/AGENTS.md`. https://learn.chatgpt.com/docs/agent-configuration/agents-md

## Tools

- RTK: filters shell output before it reaches the model. Bash tool only. https://github.com/rtk-ai/rtk
- Ponytail: makes the agent write the minimal code that works (YAGNI, standard library first). https://github.com/DietrichGebert/ponytail
- Context7 MCP: current library docs on demand; write "use context7" in the prompt. Free API key for higher limits: export `CONTEXT7_API_KEY` before installing. https://github.com/upstash/context7
- Playwright MCP: the agent drives a browser to verify UI changes. In a container: headless Chrome, installed by the script. https://github.com/microsoft/playwright-mcp
- codegraph: repository graph over MCP, one query instead of many file reads. Per repository. https://github.com/colbymchenry/codegraph
- Code intelligence plugins (Claude Code): `typescript-lsp`, `pyright-lsp`. Diagnostics after every edit, go to definition, find references. https://code.claude.com/docs/en/discover-plugins

## Per repository

Project instructions go in the repo's `AGENTS.md` with `CLAUDE.md` containing `@AGENTS.md`; Next.js 16.3+ generates both itself on `next dev`. https://nextjs.org/docs/app/guides/ai-agents

codegraph:

```sh
codegraph init --yes && codegraph install --target=claude,codex --location=local --no-permissions --yes
```

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
  "remoteControlAtStartup": true
}
```

Codex, `~/.codex/config.toml` (https://learn.chatgpt.com/docs/config-file/config-reference):

```toml
model_reasoning_effort = "medium"
plan_mode_reasoning_effort = "high"
analytics.enabled = false
```

## Tips

- Plan mode before non-trivial changes: `Shift+Tab` until `plan mode on`, or `claude --permission-mode plan`. Reads and proposes, edits nothing until approved. https://code.claude.com/docs/en/common-workflows
- `/code-review` before committing. `/simplify` (over-engineering, reuse) and `/security-review` are present in Claude Code 2.1.269. https://code.claude.com/docs/en/skills
- `/clear` between unrelated tasks. https://code.claude.com/docs/en/costs
- `/advisor opus` (or `fable`): a stronger model reviews plans and work while `sonnet` does the typing. Subscription and API only; its tokens count toward the plan. https://code.claude.com/docs/en/advisor
- `/model opusplan`: Opus in plan mode, Sonnet for execution. `/effort` per task: low for routine edits, high for hard debugging. https://code.claude.com/docs/en/model-config
- Never set `DISABLE_TELEMETRY`, `DO_NOT_TRACK`, `DISABLE_GROWTHBOOK`, or `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC`: each turns off the advisor and Remote Control. https://code.claude.com/docs/en/env-vars
- A `haiku` subagent in `~/.claude/agents/` that runs tests and builds and returns only failures keeps that output out of the main context. https://code.claude.com/docs/en/sub-agents
- One project file for both agents: instructions in `AGENTS.md`, `CLAUDE.md` containing only `@AGENTS.md`. https://code.claude.com/docs/en/memory
- Auto memory: corrections you give persist per project in `~/.claude/projects/<project>/memory/`. Same source.
- `/fewer-permission-prompts` writes an allowlist of read-only commands to the project settings (bundled in Claude Code 2.1.269).
- Codex: leave `service_tier` unset; `"fast"` costs 2.5x credits on GPT-6 Astra. https://learn.chatgpt.com/docs/agent-configuration/speed
- Codex: plugin hooks must be trusted in `/hooks` again after every plugin update. https://learn.chatgpt.com/docs/hooks
- Plan usage: `/usage` in Claude Code, `/status` in Codex. From local logs: `npx ccusage@latest` (https://github.com/ccusage/ccusage).
- A console window per prompt or tool call on Windows is a hook: `hooks` in `~/.claude/settings.json`, plugin hooks (Ponytail has three), `~/.codex/hooks.json`.
