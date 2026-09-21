---
name: payload-collection
description: Add or change a Payload 3 collection (fields, access, hooks), regenerate types, and create the migration. Use for new content types or schema changes in a Payload project.
---

Match the installed major version: https://payloadcms.com/docs/configuration/collections and https://payloadcms.com/docs/database/migrations

1. `src/collections/<Name>.ts`: export a `CollectionConfig` with `slug` and `fields`; add `access`, `hooks`, `admin` only when the task needs them.
2. Register it in `payload.config.ts` under `collections`.
3. `pnpm payload generate:types`; fix type errors in code that uses the collection.
4. Postgres or SQLite with migrations: `pnpm payload migrate:create <name>`, review `src/migrations/`, then `pnpm payload migrate`. Development on Postgres uses push mode; do not mix both on one database.
5. Verify in the admin at `/admin/collections/<slug>`: create one document, check required fields and access.
