# AGENTS.md

## Stack
- TinaCMS (Git-backed, Markdown, MDX, JSON) on a Next.js site. Content model in `tina/config.ts`.

## Commands
- Dev: `npx tinacms dev -c "next dev"` (compiles the schema, generates the client and types, GraphQL on http://localhost:4001; admin at `/admin`)
- Build: `npx tinacms build` (compiles and validates the schema, generates client and types, waits for indexing)
- Audit content: `npx tinacms audit` (file extensions and GraphQL errors per file)

## Env
- `NEXT_PUBLIC_TINA_CLIENT_ID`, `TINA_TOKEN` for Tina Cloud. Never commit them.

## Conventions
- Every content-model change goes through `tina/config.ts`; dev or build regenerates the client and types before code uses them.

## Docs
- https://tina.io/llms.txt, https://tina.io/docs/cli-overview

## Skills
- `npx skills add jezweb/claude-skills@tinacms` (community)

## Pitfalls
- TODO

## Do not touch
- TODO
