# AGENTS.md

## Stack
- Medusa v2 backend. Node 20.19+ or 22.12+ (LTS only), PostgreSQL. Optional Next.js starter storefront on http://localhost:8000.

## Commands
- Install: `npm ci`
- Dev: `npm run dev` (API http://localhost:9000, admin http://localhost:9000/app)
- Migrations: `npx medusa db:generate <module>` after model changes, then `npx medusa db:migrate` (runs migrations and syncs links). Undo: `npx medusa db:rollback <module>`.
- Tests: `npm run test:unit`, `npm run test:integration:http`, `npm run test:integration:modules` (Jest with `@medusajs/test-utils`)

## Layout (`src/`)
- `modules/` business logic and data models, `api/` routes, `workflows/`, `subscribers/` event listeners, `jobs/` scheduled, `links/` module links, `admin/` widgets and UI routes, `scripts/`.

## Conventions
- New data lives in a module: `models/*.ts` (`model.define`), `service.ts` (extends `MedusaService`), `index.ts` (`Module(...)`), registered in `medusa-config.ts` under `modules`. Then generate and run the migration.
- Route tests go in `integration-tests/http`, module tests in `src/modules/<name>/__tests__`.

## Docs
- https://docs.medusajs.com/llms.txt (index for agents). Modules: https://docs.medusajs.com/learn/fundamentals/modules. CLI: https://docs.medusajs.com/resources/medusa-cli/commands/db

## Skills
- `npx skills add medusajs/medusa-agent-skills@building-with-medusa` (also `@storefront-best-practices`, `@building-admin-dashboard-customizations`)

## Pitfalls
- TODO

## Do not touch
- TODO
