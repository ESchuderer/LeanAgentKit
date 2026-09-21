---
name: tinacms-schema
description: Change a TinaCMS content model in tina/config.ts (collections, fields, templates), regenerate the client and types, and validate existing content. Use for any schema or field change in a TinaCMS site.
---

Source: https://tina.io/docs/cli-overview and https://tina.io/llms.txt

1. Edit the collection or field in `tina/config.ts`; keep `name`, `path`, and `format` consistent with the existing content files.
2. Run the dev command from AGENTS.md (`npx tinacms dev -c "<framework dev command>"`): it compiles the schema, regenerates the typed client, and serves GraphQL on http://localhost:4001.
3. `npx tinacms audit` to find content that no longer matches the schema; fix the content or the schema.
4. Check the field in the admin at `/admin`. `npx tinacms build` must pass before deploy.
