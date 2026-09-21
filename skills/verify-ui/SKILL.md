---
name: verify-ui
description: Verify a web UI change in a real browser with the Playwright MCP tools (open the route, read console and network errors, exercise the change, screenshot) instead of assuming it works. Use after editing pages, components, styles, or routes in Next.js, Astro, Payload admin, Medusa admin, or TinaCMS.
---

1. Take the dev server URL and start command from AGENTS.md. If nothing listens on it, start the dev server in the background and wait until it answers.
2. With the Playwright MCP tools: navigate to the changed route, wait for it to settle, read console messages and failed network requests, exercise the changed interaction once (click, submit, navigate), take a screenshot.
3. Fix errors the change caused, then repeat step 2 until console and network are clean for that route.
4. Report: route checked, what was exercised, and any console errors that predate the change (leave those unless asked).

Never claim a UI change works without steps 2 and 3.
