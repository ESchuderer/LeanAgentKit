---
name: astro-content
description: Add or change an Astro content collection (schema, loader, entries, pages that query it). Use for blog posts, docs, or any structured Markdown, MDX, JSON, or YAML content in an Astro site.
---

Source: https://docs.astro.build/en/guides/content-collections/

1. `src/content.config.ts`: `defineCollection({ loader: glob({ base: './src/content/<name>', pattern: '**/*.{md,mdx}' }), schema: z.object({ ... }) })`, exported in `collections`.
2. Entries under `src/content/<name>/`; frontmatter must satisfy the schema.
3. `npx astro sync`, then query with `getCollection('<name>')` or `getEntry`, and `render(entry)` for `<Content />` and headings.
4. Routes come from `src/pages/`; a collection generates none by itself.
5. `npx astro check` and `npm run build` must pass.
