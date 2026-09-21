# AGENTS.md

## Stack
- Astro, TypeScript. Node 22.12+ (odd-numbered Node versions are unsupported). Astro is installed locally, never globally.

## Commands
- Install: `npm ci`
- Dev: `npm run dev`
- Check: `npx astro check` (diagnostics and type-checking of `.astro` files)
- Types: `npx astro sync` (regenerates `.astro/types.d.ts`; run after content or collection changes)
- Build: `npm run build` (to `dist/`), then `npm run preview`
- Add an integration: `npx astro add <name>`

## Layout
- `src/pages/` file routes, `src/content/` collection entries, `src/content.config.ts` collection schemas, `src/components/`, `src/layouts/`, `public/` served as-is, `astro.config.mjs`.

## Conventions
- Content collections: `defineCollection` with a `glob` or `file` loader and a zod schema; query with `getCollection` and `getEntry`; `render(entry)` gives `<Content />` and headings. Collections generate no routes by themselves. Skill: `/astro-content` or `$astro-content`.

## Docs
- https://docs.astro.build/en/reference/cli-reference/, https://docs.astro.build/en/guides/content-collections/

## Pitfalls
- TODO

## Do not touch
- TODO
