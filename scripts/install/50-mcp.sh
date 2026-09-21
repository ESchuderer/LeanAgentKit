#!/bin/sh
# MCP servers, user scope: Context7 (current library docs), Playwright (browser checks).
# Optional: export CONTEXT7_API_KEY for higher rate limits (free at context7.com/dashboard).
set -eu
. "$ROOT/scripts/lib.sh"
key=${CONTEXT7_API_KEY:-}
if have claude; then
  claude mcp remove --scope user context7 >/dev/null 2>&1 || true
  if [ -n "$key" ]; then claude mcp add --scope user --header "Authorization: Bearer $key" --transport http context7 https://mcp.context7.com/mcp
  else claude mcp add --scope user --transport http context7 https://mcp.context7.com/mcp; fi
  claude mcp remove --scope user playwright >/dev/null 2>&1 || true
  claude mcp add --scope user playwright -- npx @playwright/mcp@latest
fi
if have codex; then
  codex mcp remove context7 >/dev/null 2>&1 || true
  if [ -n "$key" ]; then codex mcp add context7 -- npx -y @upstash/context7-mcp --api-key "$key"
  else codex mcp add context7 -- npx -y @upstash/context7-mcp; fi
  codex mcp remove playwright >/dev/null 2>&1 || true
  codex mcp add playwright -- npx @playwright/mcp@latest
fi
