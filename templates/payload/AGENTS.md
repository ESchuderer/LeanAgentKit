# AGENTS.md

## Stack
- Payload 3 inside Next.js (`app/`). Node 20.9+. One database adapter: `@payloadcms/db-postgres`, `@payloadcms/db-mongodb`, or `@payloadcms/db-sqlite`. Payload prefers pnpm.

## Commands
- Install: `pnpm install --frozen-lockfile`
- Dev: `pnpm dev` (admin at http://localhost:3000/admin)
- Types: `pnpm payload generate:types` after any collection or config change (writes `payload-types.ts`)
- Migrations (Postgres, SQLite): `pnpm payload migrate:create [name]`, `pnpm payload migrate`, `pnpm payload migrate:status`
- Build: `pnpm build`

## Layout
- `payload.config.ts` at the root or next to `app/`; `src/collections/*.ts`; `src/migrations/`.

## Conventions
- One collection per file exporting a `CollectionConfig` (`slug`, `fields`, plus `access`, `hooks`, `admin` only when needed), registered under `collections` in `payload.config.ts`.
- Postgres: development uses push mode, production uses migrations. Do not mix both against one database.

## Docs
- Match the installed major version: https://payloadcms.com/llms.txt. Collections: https://payloadcms.com/docs/configuration/collections. Migrations: https://payloadcms.com/docs/database/migrations

## Skills
- `npx skills add payloadcms/payload@payload`; migrations from another CMS: `payloadcms/skills@cms-migration`

## Pitfalls
- TODO

## Do not touch
- TODO
