---
name: project-skills
description: "Install, update, or remove agent skills in one repository for Claude Code and Codex: the ECC base and stack skills from affaan-m/ECC and others, picked from the detected stack, through the skills CLI or the ECC installer one skill at a time. Use when the user asks to add, update, or remove skills or ECC components in a project."
---

# Project skills

Run by `project-setup` or `project-add`: use their answers, ask only what is missing. Project scope only.

Never the `ecc@ecc` plugin or `install --profile`: every installed skill and agent puts its description in context each session. Measured on ECC 2.2.3, project target, no hooks: `minimal` 489 files (87 skills, 69 agents, 122 rules), `full` 978 files. ECC context profiles (`ecc profile`, `lean@1`) are a read-only preview in 2.2.3.

## Detect

Manifests: `package.json` dependencies, `pyproject.toml` / `requirements*.txt` / `uv.lock`, `go.mod`, `Cargo.toml`, `pom.xml` / `build.gradle*`, `composer.json`, `Gemfile`, `*.csproj`, `pubspec.yaml`, `Package.swift`, `Dockerfile`, Kubernetes manifests, `prisma/schema.prisma`, database drivers, migration directories, `playwright.config.*`.

## Pick

ECC base plus the matching rows. Skip installed skills. Show the list, one line per skill.

| Detected | Skills |
|---|---|
| ECC base, every code project | `affaan-m/ECC`: `tdd-workflow`, `verification-loop` (`documentation-lookup` is global) |
| React | `affaan-m/ECC`: `react-patterns`, `react-performance`, `react-testing` |
| Next.js | `affaan-m/ECC`: `nextjs-turbopack`; `vercel/next.js`: `next-dev-loop` |
| Vue / Nuxt | `affaan-m/ECC`: `vue-patterns` / `nuxt4-patterns` |
| Angular | `affaan-m/ECC`: `angular-developer` |
| Vite, no framework above | `affaan-m/ECC`: `vite-patterns` |
| Bun | `affaan-m/ECC`: `bun-runtime` |
| NestJS | `affaan-m/ECC`: `nestjs-patterns` |
| Astro | `astrolicious/agent-skills`: `astro` |
| Payload | `payloadcms/payload`: `payload` |
| Medusa | `medusajs/medusa-agent-skills`: `building-with-medusa` (+ `building-admin-dashboard-customizations`, `storefront-best-practices` when present) |
| Python | `affaan-m/ECC`: `python-patterns`, `python-testing`; `uv.lock`: `mindrally/skills`: `python-uv` |
| Django | `affaan-m/ECC`: `django-patterns`, `django-tdd` |
| FastAPI | `affaan-m/ECC`: `fastapi-patterns` |
| Go | `affaan-m/ECC`: `golang-patterns`, `golang-testing` |
| Rust | `affaan-m/ECC`: `rust-patterns`, `rust-testing` |
| Spring Boot | `affaan-m/ECC`: `springboot-patterns`, `springboot-tdd` |
| Kotlin | `affaan-m/ECC`: `kotlin-patterns`, `kotlin-testing` |
| Swift / SwiftUI | `affaan-m/ECC`: `swiftui-patterns` |
| Flutter | `affaan-m/ECC`: `dart-flutter-patterns` |
| Laravel | `affaan-m/ECC`: `laravel-patterns`, `laravel-tdd` |
| Rails | `affaan-m/ECC`: `rails-patterns` |
| C++ | `affaan-m/ECC`: `cpp-coding-standards`, `cpp-testing` |
| .NET | `affaan-m/ECC`: `dotnet-patterns`, `csharp-testing` |
| PostgreSQL / MySQL / Redis | `affaan-m/ECC`: `postgres-patterns` / `mysql-patterns` / `redis-patterns` |
| Prisma | `affaan-m/ECC`: `prisma-patterns` |
| migrations directory | `affaan-m/ECC`: `database-migrations` |
| Docker / Kubernetes | `affaan-m/ECC`: `docker-patterns` / `kubernetes-patterns` |
| Playwright | `affaan-m/ECC`: `e2e-testing` |

Other needs: `npx skills add affaan-m/ECC --list`, `npx -y ecc-universal@latest consult "<need>" --target claude`, `npx skills find <keyword>`.

## Install

Route: the answer from `project-setup`; otherwise `.claude/ecc/install-state.json` present means ECC installer, else skills CLI. A skill installed by one route must be removed before the other installs it (the installer refuses symlinked skill paths).

### Skills CLI (default)

```sh
npx -y skills add affaan-m/ECC -s <skill> -s <skill> -a claude-code -a codex -y
npx -y skills add <owner/repo> -s <skill> -a claude-code -a codex -y
```

Writes `.agents/skills/<skill>/` (Codex), a symlink in `.claude/skills/` (Claude Code), and `skills-lock.json`. Update: `npx skills update -p`. Remove: `npx skills remove <skill> -a claude-code -a codex -y`. Restore from the lockfile: `npx skills experimental_install`.

### ECC installer, per skill (Claude Code)

1. `npx -y ecc-universal@latest install --target claude-project --skills <a,b> --dry-run`. Every selected module must be `skill-<id>`. Skills bound to a whole module install with the skills CLI instead; 15 in 2.2.3, among them `tdd-workflow`, `verification-loop`, `vue-patterns` (`tdd-workflow` alone plans 113 files).
2. Same command without `--dry-run`. Writes `.claude/skills/<skill>/`, `.claude/ecc/install-state.json`, and, if no attribution setting exists, `"includeCoAuthoredBy": false` in `.claude/settings.json` (turns off the Claude co-author trailer, stays after uninstall). Tell the user; delete the key to keep the trailer.
3. Codex: the installer writes only to `~/.codex`, so install the same skills with the skills CLI and `-a codex`.
4. Manage: `npx -y ecc-universal@latest list-installed`, `doctor`, `repair`, `uninstall --target claude-project`.

## ECC extras

On request only. Installer rows are Claude Code only.

| Extra | How | Cost |
|---|---|---|
| `context-budget`, `token-budget-advisor` | either route | one skill each |
| instinct system | installer `--skills continuous-learning-v2` (12 files), then the PreToolUse/PostToolUse block from its SKILL.md in `.claude/settings.json` | bash hook on every tool call |
| agentshield | `npx -y ecc-agentshield scan` | nothing installed; audits the Claude Code configuration |
| ECC rules | installer `--modules rules-core` | 122 files; `common` (18 KB) loads every session, language rules load for matching files; overlaps global rules |
| ECC agents | installer `--modules agents-core` | all 68 agents plus 39 skills |
| hook runtime | installer `--modules hooks-runtime --enable-hooks` | 241 files, hooks on every prompt and tool call |
