# Skills

A skill is a `SKILL.md` instruction set the agent loads on demand. Take them from their authors. The `skills` CLI installs into the current project (`-g` for every project) for Claude Code, Codex, and 75+ agents: https://github.com/vercel-labs/skills

```sh
npx skills find <keyword>
npx skills add <owner/repo@skill>
npx skills add <owner/repo> --list     # every skill in a repo, with descriptions
```

Install counts are from the registry on 2026-09-22; descriptions are the authors' own, shortened.

## Top 20

| Skill | Installs | Does |
|---|---|---|
| [vercel-labs/skills@find-skills](https://github.com/vercel-labs/skills) | 3.5M | finds and installs a skill when you ask "is there a skill for X" |
| [mattpocock/skills@grill-me](https://github.com/mattpocock/skills) | 1.2M | a relentless interview to sharpen a plan or design |
| [mattpocock/skills@tdd](https://github.com/mattpocock/skills) | 942.7K | test-first features and bug fixes, red-green-refactor, integration tests |
| [anthropics/skills@frontend-design](https://github.com/anthropics/skills) | 908.7K | distinctive visual design: aesthetic direction, typography, no templated defaults |
| [vercel-labs/agent-browser@agent-browser](https://github.com/vercel-labs/agent-browser) | 900.7K | browser automation CLI: navigate, fill forms, click, screenshot, test web apps |
| [vercel-labs/agent-skills@vercel-react-best-practices](https://github.com/vercel-labs/agent-skills) | 732.4K | React and Next.js performance guidelines from Vercel Engineering |
| [mattpocock/skills@teach](https://github.com/mattpocock/skills) | 690.5K | teaches you a skill or concept inside the workspace |
| [mattpocock/skills@domain-modeling](https://github.com/mattpocock/skills) | 675.9K | build and sharpen the project's domain model, CONTEXT.md, ADRs |
| [vercel-labs/agent-skills@web-design-guidelines](https://github.com/vercel-labs/agent-skills) | 654.8K | review UI code against Web Interface Guidelines: accessibility, UX |
| [mattpocock/skills@codebase-design](https://github.com/mattpocock/skills) | 654.7K | design deep modules: interfaces, seams, testability |
| [mattpocock/skills@diagnosing-bugs](https://github.com/mattpocock/skills) | 642.1K | diagnosis loop for hard bugs and performance regressions |
| [mattpocock/skills@implement](https://github.com/mattpocock/skills) | 593.2K | implement a piece of work from a spec or tickets |
| [mattpocock/skills@code-review](https://github.com/mattpocock/skills) | 593.1K | review changes since a commit against the repo's standards and the spec |
| [mattpocock/skills@to-spec](https://github.com/mattpocock/skills) | 541.6K | turn the conversation into a spec in the issue tracker |
| [mattpocock/skills@research](https://github.com/mattpocock/skills) | 541.3K | investigate a question against primary sources into a Markdown file |
| [mattpocock/skills@resolving-merge-conflicts](https://github.com/mattpocock/skills) | 519.9K | resolve an in-progress merge or rebase conflict |
| [anthropics/skills@skill-creator](https://github.com/anthropics/skills) | 387.3K | create, improve, and benchmark skills |
| [obra/superpowers@brainstorming](https://github.com/obra/superpowers) | 371.2K | explore intent, requirements, and design before any creative work |
| [obra/superpowers@systematic-debugging](https://github.com/obra/superpowers) | 266.7K | on any bug or failing test, before proposing fixes |
| [obra/superpowers@requesting-code-review](https://github.com/obra/superpowers) | 234.4K | verify finished work against requirements before merging |

Whole sets: `mattpocock/skills@setup-matt-pocock-skills` (870.8K) configures a repo for that set (issue tracker, domain docs); `obra/superpowers@using-superpowers` is the entry point of its 15 (planning, TDD, debugging, review, worktrees, verification before completion).

## Verify in a browser

| Skill | Installs | Does |
|---|---|---|
| [microsoft/playwright-cli@playwright-cli](https://github.com/microsoft/playwright-cli) | 161.7K | automate browser interactions and Playwright tests from a CLI |
| [anthropics/skills@webapp-testing](https://github.com/anthropics/skills) | 161.1K | Playwright toolkit for local web apps: verify, debug, screenshots, browser logs |
| [currents-dev/playwright-best-practices-skill@playwright-best-practices](https://github.com/currents-dev/playwright-best-practices-skill) | 84.8K | community |

## Per stack

| Stack | Skill |
|---|---|
| Next.js | [vercel/next.js@next-dev-loop](https://github.com/vercel/next.js/tree/canary/skills), plus the cache-components adoption and optimizer and partial-prefetching adoption skills. https://nextjs.org/docs/app/guides/ai-agents |
| Medusa | [medusajs/medusa-agent-skills](https://github.com/medusajs/medusa-agent-skills): `@building-with-medusa`, `@storefront-best-practices`, `@building-admin-dashboard-customizations` |
| Payload | [payloadcms/payload@payload](https://github.com/payloadcms/payload), [payloadcms/skills@cms-migration](https://github.com/payloadcms/skills) |
| Astro | [astrolicious/agent-skills@astro](https://github.com/astrolicious/agent-skills) (community, 15.6K) |
| TinaCMS | [jezweb/claude-skills@tinacms](https://github.com/jezweb/claude-skills) (community, 308) |
| Node.js | [mcollina/skills@nodejs-core](https://github.com/mcollina/skills) (Node.js TSC member) |
| Python with uv | [mindrally/skills@python-uv](https://github.com/mindrally/skills) (community, 915) |
| TypeScript | [wshobson/agents@typescript-advanced-types](https://github.com/wshobson/agents) (community, 78K) |

Left out of the top list on purpose: `juliusbrussee/caveman` (removed from this setup), and the video, Lark, and Azure skills that fill the rest of the leaderboard.
