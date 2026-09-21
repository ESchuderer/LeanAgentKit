# AGENTS.md

Next.js 16.3+ writes its own managed block (BEGIN:nextjs-agent-rules) into this file on `next dev`. Keep everything here outside those markers. https://nextjs.org/docs/app/guides/ai-agents

## Stack
- Next.js App Router, TypeScript, Tailwind, ESLint. Node 20.9+.

## Commands
- Install: `npm ci`
- Dev: `npm run dev` (http://localhost:3000, Turbopack)
- Lint: `npm run lint` (`eslint`; `next build` no longer lints since Next.js 16)
- Types: `npx tsc --noEmit`
- Build: `npm run build`

## Docs
- Read `node_modules/next/dist/docs/` before writing Next.js code; it matches the installed version. Online: append `.md` to any nextjs.org/docs URL.

## Agent tooling
- `.mcp.json` with `next-devtools-mcp` gives the agent build and runtime errors, routes, and logs from the running dev server (Next.js 16+). https://nextjs.org/docs/app/guides/mcp

```json
{ "mcpServers": { "next-devtools": { "command": "npx", "args": ["-y", "next-devtools-mcp@latest"] } } }
```

- Official skills: `npx skills add vercel/next.js@next-dev-loop`, then prompt: After every edit, verify the page still works at runtime using the next-dev-loop Skill.

## Layout
- Routes in `app/`: `page.tsx`, `layout.tsx`, `route.ts`; the root layout owns `<html>` and `<body>`. Static files in `public/`. Import alias `@/*`.

## Pitfalls
- TODO

## Do not touch
- TODO
