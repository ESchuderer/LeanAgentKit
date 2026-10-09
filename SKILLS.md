# Skills

A skill is a `SKILL.md` instruction set the agent loads on demand. The `skills` CLI installs into the current project (`-g` for every project) for Claude Code, Codex, and 75+ agents: https://github.com/vercel-labs/skills

```sh
npx skills find <keyword>
npx skills add <owner/repo> --list     # every skill in a repo, with descriptions
```

The `project-setup` and `project-add` skills install the stack-specific ones per project ([README](README.md#per-repository)). ECC ([README](README.md#ecc)): `npx skills add affaan-m/ECC --list`.

| Skill | Install | Does |
|---|---|---|
| [find-skills](https://github.com/vercel-labs/skills) | `npx skills add vercel-labs/skills@find-skills` | finds and installs a skill when you ask "is there a skill for X" |
| [grill-me](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@grill-me` | a relentless interview to sharpen a plan or design |
| [tdd-workflow](https://github.com/affaan-m/ECC/tree/main/skills/tdd-workflow) | `npx skills add affaan-m/ECC -s tdd-workflow` | test-first features and bug fixes: failing test, smallest change to green, refactor |
| [verification-loop](https://github.com/affaan-m/ECC/tree/main/skills/verification-loop) | `npx skills add affaan-m/ECC -s verification-loop` | build, types, lint, tests, security grep, diff review; PASS/FAIL report |
| [frontend-design](https://github.com/anthropics/skills) | `npx skills add anthropics/skills@frontend-design` | distinctive visual design: aesthetic direction, typography, no templated defaults |
| [agent-browser](https://github.com/vercel-labs/agent-browser) | `npx skills add vercel-labs/agent-browser@agent-browser` | browser automation CLI: navigate, fill forms, click, screenshot, test web apps |
| [react-performance](https://github.com/affaan-m/ECC/tree/main/skills/react-performance) | `npx skills add affaan-m/ECC -s react-performance` | React and Next.js performance rules, adapted from Vercel's React Best Practices |
| [teach](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@teach` | teaches you a skill or concept inside the workspace |
| [domain-modeling](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@domain-modeling` | build and sharpen the project's domain model, CONTEXT.md, ADRs |
| [web-design-guidelines](https://github.com/vercel-labs/agent-skills) | `npx skills add vercel-labs/agent-skills@web-design-guidelines` | review UI code against Web Interface Guidelines: accessibility, UX |
| [codebase-design](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@codebase-design` | design deep modules: interfaces, seams, testability |
| [diagnosing-bugs](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@diagnosing-bugs` | diagnosis loop for hard bugs and performance regressions |
| [implement](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@implement` | implement a piece of work from a spec or tickets |
| [code-review](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@code-review` | review changes since a commit against the repo's standards and the spec |
| [to-spec](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@to-spec` | turn the conversation into a spec in the issue tracker |
| [research](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@research` | investigate a question against primary sources into a Markdown file |
| [resolving-merge-conflicts](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@resolving-merge-conflicts` | resolve an in-progress merge or rebase conflict |
| [setup-matt-pocock-skills](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@setup-matt-pocock-skills` | configures a repo for the mattpocock skills (issue tracker, domain docs); run once before the others |
| [playwright-cli](https://github.com/microsoft/playwright-cli) | `npx skills add microsoft/playwright-cli@playwright-cli` | automate browser interactions and Playwright tests from a CLI |
| [webapp-testing](https://github.com/anthropics/skills) | `npx skills add anthropics/skills@webapp-testing` | Playwright toolkit for local web apps: verify, debug, screenshots, browser logs |
| [next-dev-loop](https://github.com/vercel/next.js/tree/canary/skills) | `npx skills add vercel/next.js@next-dev-loop` | Next.js: verify each edit against the running dev server through its MCP server and the browser |
| [next-cache-components-adoption](https://github.com/vercel/next.js/tree/canary/skills) | `npx skills add vercel/next.js@next-cache-components-adoption` | Next.js: migrate an app to Cache Components, route by route |
| [next-cache-components-optimizer](https://github.com/vercel/next.js/tree/canary/skills) | `npx skills add vercel/next.js@next-cache-components-optimizer` | Next.js: make a route's navigation instant, guarded by an `instant()` e2e test |
| [next-partial-prefetching-adoption](https://github.com/vercel/next.js/tree/canary/skills) | `npx skills add vercel/next.js@next-partial-prefetching-adoption` | Next.js: move an app onto Partial Prefetching |
| [building-with-medusa](https://github.com/medusajs/medusa-agent-skills) | `npx skills add medusajs/medusa-agent-skills@building-with-medusa` | Medusa backend: modules, API routes, workflows, data models, module links |
| [building-admin-dashboard-customizations](https://github.com/medusajs/medusa-agent-skills) | `npx skills add medusajs/medusa-agent-skills@building-admin-dashboard-customizations` | Medusa admin UI: widgets, custom pages, forms, tables, data loading |
| [storefront-best-practices](https://github.com/medusajs/medusa-agent-skills) | `npx skills add medusajs/medusa-agent-skills@storefront-best-practices` | Medusa storefronts: checkout, cart, payment, product pages, navigation |
| [payload](https://github.com/payloadcms/payload) | `npx skills add payloadcms/payload@payload` | Payload: config, collections, fields, hooks, access control, API; debugging validation, relationships, transactions |
| [cms-migration](https://github.com/payloadcms/skills) | `npx skills add payloadcms/skills@cms-migration` | migrate content from WordPress, Contentful, Strapi, Sanity, Webflow, or similar to Payload |
| [astro](https://github.com/astrolicious/agent-skills) | `npx skills add astrolicious/agent-skills@astro` | Astro: components, pages, SSR adapters, content collections, deployment, CLI |
| [python-uv](https://github.com/mindrally/skills) | `npx skills add mindrally/skills@python-uv` | Python dependency management with uv |
| [typescript-advanced-types](https://github.com/wshobson/agents) | `npx skills add wshobson/agents@typescript-advanced-types` | generics, conditional and mapped types, template literals, utility types |
| [pr](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@pr` | pull request body: evidence, merge risk |
| [retro](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@retro` | after a session: environment improvements, most severe first |
| [prototype](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@prototype` | throwaway prototype that answers a design question |
| [wayfinder](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@wayfinder` | plan large work as a map of decision tickets |
| [to-tickets](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@to-tickets` | break a plan or spec into tickets with blocking edges, tracker or local file |
| [implement-spec](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@implement-spec` | implement a whole spec on one branch with parallel subagents |
| [improve-codebase-architecture](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@improve-codebase-architecture` | scan for module-deepening opportunities, HTML report |
| [writing-for-agents](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@writing-for-agents` | write skills, `AGENTS.md`, and other agent-facing docs |
| [doubt-driven-development](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@doubt-driven-development` | adversarial fresh-context review of non-trivial decisions while work proceeds |
| [constraint-driven-development](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@constraint-driven-development` | quality bar in `CONSTRAINTS.md`, checks placed by cost, catches silenced checks and skipped tests |
| [api-and-interface-design](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@api-and-interface-design` | contract-first design, Hyrum's Law, error semantics, boundary validation |
| [deprecation-and-migration](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@deprecation-and-migration` | deprecation types, migration patterns, zombie code removal |
| [observability-and-instrumentation](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@observability-and-instrumentation` | structured logging, RED metrics, OpenTelemetry tracing, symptom-based alerting |
| [ci-cd-and-automation](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@ci-cd-and-automation` | shift-left testing, feature flags, quality-gate pipelines |
| [shipping-and-launch](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@shipping-and-launch` | pre-launch checklist, flag lifecycle, staged rollout, rollback |
| [context-engineering](https://github.com/addyosmani/agent-skills) | `npx skills add addyosmani/agent-skills@context-engineering` | rules files and MCP integrations: the right information at the right time |

addyosmani/agent-skills: a single-skill install leaves out the repository's shared `references/`; its other skills overlap this kit (TDD, code review, debugging, security, spec writing). mattpocock engineering skills need `setup-matt-pocock-skills` once per repository.
