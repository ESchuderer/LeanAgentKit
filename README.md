# LeanAgentKit

Global rules, settings, tools, project templates, and skills for Claude Code and Codex.

## Install

```sh
sh scripts/install.sh      # Windows: from Git Bash. Needs git, node, and the claude and codex CLIs.
sh scripts/uninstall.sh
```

One file per step in `scripts/install/` and `scripts/uninstall/`; delete a line in `scripts/install.sh` to skip a step. Each step calls the tool's own installer. Steps: rules, settings, RTK, Ponytail, MCP servers (Context7, Playwright), codegraph and Serena CLIs, LSP plugins, skills. Edited files are backed up to `~/.leanagentkit/backups/`.

After the run: in Codex run `/hooks` and trust the Ponytail hooks; restart both agents.

## Global rules

[rules/global.md](rules/global.md). Project instructions override it.

- Claude Code: `~/.claude/rules/00-leanagentkit-global.md`, loaded every session before project rules. https://code.claude.com/docs/en/memory
- Codex: marked block at the top of `~/.codex/AGENTS.md`. https://learn.chatgpt.com/docs/agent-configuration/agents-md

## Tools

- RTK: filters shell output before it reaches the model. Bash tool only. https://github.com/rtk-ai/rtk
- Ponytail: makes the agent write the minimal code that works (YAGNI, standard library first). https://github.com/DietrichGebert/ponytail
- Context7 MCP: current library docs on demand; write "use context7" in the prompt. Free API key for higher limits: export `CONTEXT7_API_KEY` before installing. https://github.com/upstash/context7
- Playwright MCP: the agent drives a browser to verify UI changes. https://github.com/microsoft/playwright-mcp
- codegraph: repository graph over MCP, one query instead of many file reads. Per repository. https://github.com/colbymchenry/codegraph
- Serena: LSP-backed symbol lookup and editing over MCP. Per repository. https://github.com/oraios/serena
- Code intelligence plugins (Claude Code): `typescript-lsp`, `pyright-lsp`. Diagnostics after every edit, go to definition, find references. https://code.claude.com/docs/en/discover-plugins

## Per repository

Project instructions go in the repo's `AGENTS.md` with `CLAUDE.md` containing `@AGENTS.md`; Next.js 16.3+ generates both itself on `next dev`. https://nextjs.org/docs/app/guides/ai-agents

One indexer per repo, never both:

```sh
codegraph init --yes && codegraph install --target=claude,codex --location=local --no-permissions --yes
claude mcp add serena -- serena start-mcp-server --context claude-code --project "$(pwd)"    # Codex: serena setup codex
```

## Skills

Skills come from their authors through the skills.sh registry: `npx skills find <keyword>` searches, `npx skills add <owner/repo@skill>` installs into the current project (`-g` for all projects) for Claude Code, Codex, and 75+ agents. https://github.com/vercel-labs/skills, https://skills.sh

- Next.js (Vercel): `vercel/next.js@next-dev-loop`, plus the cache-components and partial-prefetching skills. https://nextjs.org/docs/app/guides/ai-agents
- Medusa (Medusa): `medusajs/medusa-agent-skills@building-with-medusa`, `@storefront-best-practices`, `@building-admin-dashboard-customizations`
- Payload (Payload): `payloadcms/payload@payload`, `payloadcms/skills@cms-migration`
- Playwright (Microsoft): `microsoft/playwright-cli@playwright-cli`, a CLI alternative to the Playwright MCP server for browser checks
- Astro (community, astrolicious): `astrolicious/agent-skills@astro`
- TinaCMS (community): `jezweb/claude-skills@tinacms`
- Node.js (Matteo Collina): `mcollina/skills@nodejs-core`
- Python with uv (community): `mindrally/skills@python-uv`

## Config

Claude Code, `~/.claude/settings.json` (https://code.claude.com/docs/en/settings):

```json
{
  "model": "sonnet",
  "env": { "DISABLE_ERROR_REPORTING": "1", "CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY": "1", "SERENA_USAGE_REPORTING": "false" },
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
- `/clear` between unrelated tasks. Carried-over context is the largest avoidable cost. https://code.claude.com/docs/en/costs
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
