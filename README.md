# LeanAgentKit

The lean architecture for AI coding. Global constraints optimized for pure execution.

## Install

```sh
sh scripts/install.sh                 # core. Windows: from Git Bash. Needs git, node, and the claude and codex CLIs.
sh scripts/install.sh full            # everything
sh scripts/install.sh 66-openspec.sh  # named steps only
sh scripts/uninstall.sh
```

| Profile | Steps |
|---|---|
| `core` | rules, settings, RTK, Ponytail, Context7 MCP, global skills (`project-*` from `skills/`, ECC `documentation-lookup`), optional issue-tracking skills (asked), check (context cost, skill scan) |
| `full` | `core` plus Codex when missing, codegraph CLI, ECC Memory Vault CLI with `unified-memory`, OpenSpec CLI, LSP plugins |

The per-repository tools (codegraph, OpenSpec, Playwright MCP, verify hook) are wired by the `project-*` skills; their CLIs install on first use.

Issue tracking (step `85-tracking.sh`, both profiles) asks, when stdin is a terminal, whether to install two optional skills from [skills-optional/](skills-optional/) ([Issue tracking](#issue-tracking)):

1. `Install issues-github: GitHub issues through the gh CLI (yes/no)`
2. `Install issues-jira: Jira Cloud work items (yes/no)`
3. after a yes to Jira: `Jira sites and project keys, - clears (https://a.atlassian.net=KEY1,KEY2;https://b.atlassian.net=KEY3)`

Every rerun asks again; Enter keeps the saved answer, an invalid answer is asked again. `LAK_GITHUB_ISSUES=yes|no`, `LAK_JIRA=yes|no` and `LAK_JIRA_SITES` (same format, `-` clears; used when the Jira answer is yes, from `LAK_JIRA`, the question, or the saved choice; it does not turn Jira on) answer a question without asking it. When stdin is not a terminal (`</dev/null`, CI) and the variable is unset: the saved choice in `~/.leanagentkit/tracking.conf`, otherwise no. A background job (`&`) keeps the terminal as stdin and stops at the first question. A skill chosen before and declined now is removed when the skills CLI lock (`~/.agents/.skill-lock.json`, or `$XDG_STATE_HOME/skills/.skill-lock.json` when that is set) records a local `skills-optional` folder as its source, so a moved or re-cloned kit still counts; a skill of the same name from another source is neither replaced nor removed, and a yes is then saved as no. End of input (Ctrl-D) keeps the saved answer; an invalid saved `jira_sites` is ignored. The choice is saved after the skills CLI result is checked, so the next run retries a failed one. No token is asked for or stored: sign in with `gh auth login`, `acli jira auth login`, the MCP OAuth sign-in, or environment variables.

```sh
LAK_GITHUB_ISSUES=yes LAK_JIRA=yes LAK_JIRA_SITES='https://a.atlassian.net=KEY1' sh scripts/install.sh 85-tracking.sh
```

Requirements:

- The `claude` and `codex` CLIs on PATH, also when you use the VS Code extensions: the extensions do not put them on PATH, and the RTK, Ponytail, MCP, and LSP steps configure an agent only through its CLI. Claude Code: `curl -fsSL https://claude.ai/install.sh | bash` (https://code.claude.com/docs/en/setup). Codex: installed when missing by `full` and inside a container.
- `npm i -g` without sudo. If npm's global folders are not writable (distribution Node.js, for example Arch): `npm config set prefix ~/.local` and `~/.local/bin` on PATH. https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
- Optional: `uv` for the skill scan in the check step, skipped without it. https://docs.astral.sh/uv/

If the npm folder is not writable, the steps that need `npm i -g` fail with this fix. Steps that need an agent's CLI skip it and say so.

One file per step in `scripts/install/` and `scripts/uninstall/`; the profile lists are in `scripts/install.sh`. Each step calls the tool's own installer. Versions are pinned in [scripts/versions.sh](scripts/versions.sh), Ponytail by commit in [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json) and [.agents/plugins/marketplace.json](.agents/plugins/marketplace.json). Update: `git pull`, rerun the same command; every step reinstalls at the pinned version (RTK from brew or winget: installed once, latest). Edited files are backed up to `~/.leanagentkit/backups/`. CI: [.github/workflows/install.yml](.github/workflows/install.yml) runs `install.sh full` and `uninstall.sh` on a fresh runner with both CLIs on every push; the issue-tracking step runs with `LAK_*` set (install), without them (saved choice kept), and declined (skills removed).

After the run: in Codex run `/hooks` and trust the Ponytail hooks; restart both agents.

## Supply chain

A skill is instructions the agent follows with its full permissions; a plugin hook runs on every prompt or tool call. Snyk's ToxicSkills audit of 3,984 published skills (February 2026) found a critical issue in 534 and confirmed 76 as malicious. https://snyk.io/blog/toxicskills-malicious-ai-agent-skills-clawhub

- Pinned: npm packages and the RTK release by version (RTK's installer verifies the release checksum), the global ECC skills and Ponytail by commit. Not pinned: the `claude` and `codex` CLIs, Anthropic's LSP plugins from `claude-plugins-official`, the hosted Context7 server, RTK through brew or winget.
- One skill at a time from a named repository, never a catalog. `skills-lock.json` records the commit and a content hash per skill; `project-skills` pins per-repository installs the same way.
- Check step: prints each global skill's description size (in context every session) and scans the global skills and plugin caches with Cisco's skill-scanner: static rules, offline, Apache-2.0, exits non-zero on a high or critical finding. `project-skills` scans a repository's skills after each install. https://github.com/cisco-ai-defense/skill-scanner
- Scanners are a filter, not a verdict: Trail of Bits bypassed every scanner it tested. Read `SKILL.md` and the scripts of a skill before keeping it, and diff before an update. https://labs.cloudsecurityalliance.org/research/csa-research-note-ai-agent-skill-scanner-bypass-20260610-csa/
- Telemetry off and no sign-in in every step: RTK, codegraph, OpenSpec, the skills CLI (`DO_NOT_TRACK` for its process only).
- Not used: Snyk Agent Scan (needs a Snyk token, uploads skill content), ECC AgentShield (`npx ecc-agentshield scan` audits `~/.claude`; 1.6.0 crashed with EISDIR on this setup).

## Global rules

[rules/global.md](rules/global.md). Its first line gives a conflicting project instruction precedence; neither agent enforces that by itself. Claude Code loads user rules before project rules and may follow either on conflict (https://code.claude.com/docs/en/memory); Codex appends the project `AGENTS.md` after the global block, later text wins, 32 KiB combined by default (https://learn.chatgpt.com/docs/agent-configuration/agents-md). Rules are context, not enforcement; the verify hook (`project-instructions`) is the enforced step.

- Claude Code: `~/.claude/rules/00-leanagentkit-global.md`, loaded every session before project rules. https://code.claude.com/docs/en/memory
- Codex: marked block at the top of `~/.codex/AGENTS.md`. https://learn.chatgpt.com/docs/agent-configuration/agents-md

## SDLC

The lifecycle both agents follow; the short form is the "SDLC" section of the global rules. `/<skill>` (Claude Code) or `$<skill>` (Codex) starts a phase by hand.

| Phase | Global (this kit) | Per repository |
|---|---|---|
| Understand | global rules (ask, sources), Context7 through `documentation-lookup`, RTK | `AGENTS.md`, codegraph MCP |
| Specify | plan mode | OpenSpec `openspec-explore`, `openspec-propose`; `grill-me` on request |
| Plan | plan mode, `advisorModel`, clear context on plan accept | `openspec-apply-change` tasks; issues for defects and one-commit tasks, milestones for phases (`issues-github`), work items and Epics (`issues-jira`), optional |
| Build | Ponytail, LSP diagnostics after each edit | ECC `tdd-workflow`, stack skills |
| Verify | `/simplify` | ECC `verification-loop`; Playwright MCP for a web UI; verify hook (opt-in): the check command runs when the agent stops and blocks "done" while it fails |
| Review | `/code-review` before push (global rule), `/security-review`, `/ponytail-review`; unfixed findings offered as issues (`issues-github`, `issues-jira`, optional) | `code-review` (mattpocock) on request |
| Ship | commit, push, pull request; `Fixes #n` (GitHub), Smart Commits or a transition (Jira) | `openspec-archive-change`, `openspec-sync-specs` |
| Hand off | Memory Vault `ecc memory handoff`, `save` (`unified-memory`, `full` profile); auto memory | `.ecc/memory/` in the repository |
| Maintain | `git pull`, rerun `install.sh` | `project-add`: revalidate skills, codegraph, OpenSpec, `AGENTS.md` |

## Tools

- RTK: filters shell output before it reaches the model. Bash tool only. https://github.com/rtk-ai/rtk
- Ponytail: makes the agent write the minimal code that works (YAGNI, standard library first). https://github.com/DietrichGebert/ponytail Pinned by commit in this repository's marketplace files.
- Context7 MCP: current library docs on demand; the ECC `documentation-lookup` skill calls it for library and API questions. Free API key for higher limits: export `CONTEXT7_API_KEY` before installing. https://github.com/upstash/context7
- Playwright MCP: the agent drives a browser to verify UI changes. Per repository with a web UI (`project-skills`): a server process and about 25 tool schemas per session elsewhere. In a container: headless Chrome. https://github.com/microsoft/playwright-mcp
- codegraph: repository graph over MCP, one query instead of many file reads. Per repository. https://github.com/colbymchenry/codegraph
- ECC Memory Vault: `ecc memory save`, `handoff`, `search` pass work state between Claude Code and Codex as Markdown files in `<repo>/.ecc/memory/project/` (git-ignored) and `team/` (versioned); `~/.ecc/memory/` only with `--scope user`. The `unified-memory` skill tells both agents when to use it. CLI only; the optional MCP server (`ecc-memory-mcp`) is not registered. Package `ecc-universal`: 19.5 MB, 2805 files, no install scripts. https://github.com/affaan-m/ECC/blob/main/skills/unified-memory/SKILL.md
- OpenSpec: spec-driven changes. A change is a folder with a proposal, tasks, and spec deltas; archiving merges the deltas into `openspec/specs/`. Per repository (`project-openspec`). CLI installed with telemetry off and delivery `skills` (no duplicate `/opsx` commands in Claude Code). https://github.com/Fission-AI/OpenSpec
- Code intelligence plugins (Claude Code): `typescript-lsp`, `pyright-lsp`. Diagnostics after every edit, go to definition, find references. https://code.claude.com/docs/en/discover-plugins

## Not used

Evaluated and left out; each is one command away.

| Tool | Why not | Install |
|---|---|---|
| Context Mode: MCP server and hooks that keep raw tool output out of context. https://github.com/mksglu/context-mode | overlaps RTK on Bash; adds 11 tools, hooks on every prompt and tool call, a SQLite store, and a sandbox that runs model-written code | `claude plugin marketplace add mksglu/context-mode && claude plugin install context-mode@context-mode` |
| Superpowers: 15 skills that run their own lifecycle, brainstorm, plan, subagents. https://github.com/obra/superpowers | a second lifecycle next to the SDLC here (OpenSpec, ECC `tdd-workflow`, `verification-loop`); its bootstrap loads at every session start | `claude plugin install superpowers@claude-plugins-official`; Codex: `/plugins` |
| claude-mem: persistent memory built from every tool call. https://github.com/thedotmack/claude-mem | five hooks, a Bun worker, LLM compression on your plan after a 30-day trial, sign-in prompt unless `CLAUDE_MEM_ONLINE_OPTIN=false`; Claude Code only. Auto memory and the Memory Vault cover the need | `npx claude-mem@13.35.0 install` |
| caveman: terse reply style. https://github.com/JuliusBrussee/caveman | the global rules already require short replies; its own benchmark puts `/caveman` 3% below "answer concisely"; its proxy overlaps RTK | `npx skills add JuliusBrussee/caveman -g` |

## Watch list

Not evaluated; early projects that may matter for this kit.

- OpenRig: Claude Code and Codex as one team defined in YAML, over tmux. https://github.com/mvschwarz/openrig
- cmux: terminal for parallel agents, one pane each. https://github.com/manaflow-ai/cmux (an unrelated `coder/cmux` exists)
- Orca: desktop app that fans one prompt to several agents, one git worktree each. https://github.com/stablyai/orca

## Per repository

Skills in [skills/](skills/), installed globally by the script. Claude Code: `/<name>`, Codex: `$<name>`. Each shows one plan and applies it after one confirmation. Every installed skill is called the same way, so `/tdd-workflow` or `$openspec-propose` starts an SDLC phase directly; otherwise the agent uses the skill of the current phase (global rules, "SDLC").

| Skill | Does |
|---|---|
| `project-setup` | first setup of a new or existing repository. Asks first: ECC install route, codegraph or not, OpenSpec or not, verify hook or not; new project also type, stack, data, extras, then scaffolds with the framework's generator |
| `project-add` | later changes: shows what is installed, then adds, updates, or removes skills, ECC extras, codegraph, OpenSpec, Playwright MCP, the verify hook, `AGENTS.md` commands |
| `project-instructions` | `AGENTS.md` with the project's commands, `CLAUDE.md` containing `@AGENTS.md`; the verify hook when chosen. Next.js 16.3+ generates both on `next dev`. https://nextjs.org/docs/app/guides/ai-agents |
| `project-codegraph` | codegraph index and MCP wiring for both agents: set up, sync, remove |
| `project-openspec` | OpenSpec in the repository for both agents: set up, update, remove |
| `project-skills` | skills for the detected stack, project scope: the SDLC base (ECC `tdd-workflow`, `verification-loop`), the matching stack ones, Playwright MCP for a web UI |

`project-setup` and `project-add` run the others. A repository gets only what its manifests show: a JavaScript project gets no Python skill, and no project gets agents, ECC rules, hooks, or modules unless asked for by name; `project-add` lists anything beyond that for removal.

## Issue tracking

Optional skills in [skills-optional/](skills-optional/), installed globally by step `85-tracking.sh` when chosen ([Install](#install)). `80-skills.sh` installs only `skills/`.

| Skill | Does |
|---|---|
| `issues-github` | review findings and work items as GitHub issues through `gh`: repository and visibility check (asks before filing in a public or internal repository; never creates a public repository or changes visibility unless told so for that repository), duplicate search over open and closed issues, one issue per finding with an area and a type label (`bug`, `enhancement`, `performance`; `needs-source-check` when a person must decide), milestones for roadmap phases, body template (Where, Problem, Failure scenario, Proposed fix, Source), `Fixes #n` commits. https://cli.github.com/manual/ |
| `issues-jira` | the same on Jira Cloud for the sites and project keys in the `jira_sites=` line of `~/.leanagentkit/tracking.conf`: JQL duplicate search, issue types, labels, components, Smart Commits when the site has them enabled, transitions instead of closing |

Both: an issue is a defect, a review finding, or a one-commit task; in a repository with `openspec/`, work that changes behaviour is an OpenSpec change that names the issue and closes it from the commit that completes its `tasks.md`; unfixed review findings are offered as issues and filed after the user agrees; issue text follows the repository's publication rules, with no secrets or personal data. GitHub transfers open issues only between repositories of one owner, never from a private to a public one; otherwise the skill copies them, and asks first when the target is public or internal. https://docs.github.com/en/issues/tracking-your-work-with-issues/administering-issues/transferring-an-issue-to-another-repository

Jira access, first route that works. The step installs none of them and stores no token.

- Atlassian CLI `acli`, sign in with `acli jira auth login --web`. https://developer.atlassian.com/cloud/acli/guides/install-acli/
- Atlassian Rovo MCP server, OAuth sign-in: `claude mcp add --transport http atlassian https://mcp.atlassian.com/v2/mcp`, then `/mcp`; `codex mcp add atlassian --url https://mcp.atlassian.com/v2/mcp`, then `codex mcp login atlassian`. Not registered by the kit: an MCP server's tool schemas load in every session. https://support.atlassian.com/atlassian-rovo-mcp-server/docs/getting-started-with-the-atlassian-remote-mcp-server/
- REST API v3, basic auth with an API token from the environment (`JIRA_EMAIL`, `JIRA_API_TOKEN`). https://developer.atlassian.com/cloud/jira/platform/basic-auth-for-rest-apis/

`uninstall.sh` removes the skills the kit installed (same lock check) and `tracking.conf`.

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

OpenSpec and ECC do not overlap: OpenSpec decides what to build and keeps the specs; ECC skills shape how the agent builds it ("SDLC" above).

| | OpenSpec 1.14.1 | ECC 2.2.3 |
|---|---|---|
| Unit | change folder: `proposal.md`, `tasks.md`, spec deltas | skill, agent, rule, hook |
| Persistent specs | `openspec/specs/`, updated on archive | none; nearest skills (`intent-driven-development`, `product-capability`, `architecture-decision-records`) write one-off plans or ADRs |
| Per repository | 6 skills per agent, about 1.8 KB of descriptions | the skills `project-skills` picks |
| Install | `npm i -g @fission-ai/openspec`, `openspec init` | `npx skills add affaan-m/ECC -s <skill>` |
| Telemetry | on by default; turned off by the install step | none found (unverified) |

## Dev containers (VS Code)

Agents and tools run in a Linux container; the repo is bind-mounted. https://code.claude.com/docs/en/devcontainer

1. Docker:
   - CachyOS/Arch: `sudo pacman -S docker docker-buildx && sudo systemctl enable --now docker && sudo usermod -aG docker $USER`, then log out and in. https://wiki.archlinux.org/title/Docker
   - Windows: `winget install Docker.DockerDesktop` (WSL 2 backend); keep repos in the WSL filesystem. https://code.visualstudio.com/docs/devcontainers/containers#_installation
2. `code --install-extension ms-vscode-remote.remote-containers`
3. VS Code user `settings.json`, applied to every dev container: adds Claude Code, clones this repo, runs `scripts/install.sh` (`core`, plus Codex when missing inside a container; LSP plugins: `sh ~/dotfiles/scripts/install.sh 70-lsp.sh`). https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories

   ```json
   "dev.containers.defaultFeatures": { "ghcr.io/anthropics/devcontainer-features/claude-code:1.0": {} },
   "dotfiles.repository": "ESchuderer/LeanAgentKit",
   "dotfiles.installCommand": "scripts/install.sh"
   ```

4. Repo without `.devcontainer/`: `Dev Containers: Add Dev Container Configuration Files`, any template. Keep both logins across rebuilds with a volume per config folder (`/home/vscode` is the template user's home; Claude Code also needs `CLAUDE_CONFIG_DIR`, since `~/.claude.json` lives outside `~/.claude`). If a folder is root-owned after the first start: `sudo chown -R vscode ~/.claude ~/.codex`. https://code.claude.com/docs/en/devcontainer#persist-authentication-and-settings-across-rebuilds Then `Dev Containers: Reopen in Container`.

   ```json
   "mounts": [
     "source=claude-config-${devcontainerId},target=/home/vscode/.claude,type=volume",
     "source=codex-config-${devcontainerId},target=/home/vscode/.codex,type=volume"
   ],
   "containerEnv": { "CLAUDE_CONFIG_DIR": "/home/vscode/.claude" }
   ```

   Issue-tracking skills in the container: add `LAK_GITHUB_ISSUES`, `LAK_JIRA`, and `LAK_JIRA_SITES` to `containerEnv`; without them the dotfiles run installs neither (its commands reach the shell on stdin, so stdin is no terminal: inferred from https://github.com/devcontainers/cli/blob/v0.89.0/src/spec-common/shellServer.ts#L86).

5. Sign in once per volume: `claude`, `codex login --device-auth`.

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
