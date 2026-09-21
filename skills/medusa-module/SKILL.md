---
name: medusa-module
description: Add or change a Medusa v2 custom module (data model, service, registration, migration, test). Use for new entities or new fields in a Medusa backend.
---

Read the current page first, it is versioned: https://docs.medusajs.com/learn/fundamentals/modules

1. `src/modules/<name>/models/<entity>.ts`: `model.define("<entity>", { id: model.id().primaryKey(), ... })`.
2. `src/modules/<name>/service.ts`: `class <Name>ModuleService extends MedusaService({ <Entity> }) {}`.
3. `src/modules/<name>/index.ts`: `export default Module(<NAME>_MODULE, { service: <Name>ModuleService })`.
4. `medusa-config.ts`: add `{ resolve: "./src/modules/<name>" }` to `modules`.
5. `npx medusa db:generate <name>`, review the migration, then `npx medusa db:migrate`.
6. Add a workflow and an API route under `src/api/` only if the task asks for them.
7. Test in `src/modules/<name>/__tests__/` and run `npm run test:integration:modules`.
