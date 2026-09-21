# AGENTS.md

## Stack
- Node.js 20+, ESM (`"type": "module"`). TypeScript optional.

## Commands
- Install: `npm ci`
- Test: `node --test` (built-in runner; picks up `*.test.js` and files under `test/`) https://nodejs.org/api/test.html
- Dev: `node --watch src/index.js`
- Lint: `npx eslint .`
- Types: `npx tsc --noEmit`

## Conventions
- Prefer built-ins over dependencies: `node:fs/promises`, `node:path`, global `fetch`, `node:test`.
- Set `engines.node` in `package.json`; commit `package-lock.json`; CI uses `npm ci`.

## Pitfalls
- TODO

## Do not touch
- TODO
