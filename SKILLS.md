# Skills

A skill is a `SKILL.md` instruction set the agent loads on demand. The `skills` CLI installs into the current project (`-g` for every project) for Claude Code, Codex, and 75+ agents: https://github.com/vercel-labs/skills

```sh
npx skills find <keyword>
npx skills add <owner/repo> --list     # every skill in a repo, with descriptions
```

| Skill | Install | Does |
|---|---|---|
| [find-skills](https://github.com/vercel-labs/skills) | `npx skills add vercel-labs/skills@find-skills` | finds and installs a skill when you ask "is there a skill for X" |
| [grill-me](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@grill-me` | a relentless interview to sharpen a plan or design |
| [tdd](https://github.com/mattpocock/skills) | `npx skills add mattpocock/skills@tdd` | test-first features and bug fixes, red-green-refactor, integration tests |
| [frontend-design](https://github.com/anthropics/skills) | `npx skills add anthropics/skills@frontend-design` | distinctive visual design: aesthetic direction, typography, no templated defaults |
| [agent-browser](https://github.com/vercel-labs/agent-browser) | `npx skills add vercel-labs/agent-browser@agent-browser` | browser automation CLI: navigate, fill forms, click, screenshot, test web apps |
| [vercel-react-best-practices](https://github.com/vercel-labs/agent-skills) | `npx skills add vercel-labs/agent-skills@vercel-react-best-practices` | React and Next.js performance guidelines from Vercel Engineering |
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
