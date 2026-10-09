#!/bin/sh
# Context7 MCP (current library docs), user scope, pinned version. Playwright MCP is per repository (project-skills).
# Optional: export CONTEXT7_API_KEY for higher rate limits (free at context7.com/dashboard).
set -eu
. "$ROOT/scripts/lib.sh"
key=${CONTEXT7_API_KEY:-}
if cli claude; then
  claude mcp remove --scope user playwright >/dev/null 2>&1 || true  # kit before 2026-10 registered it globally
  claude mcp remove --scope user context7 >/dev/null 2>&1 || true
  if [ -n "$key" ]; then claude mcp add --scope user --header "Authorization: Bearer $key" --transport http context7 https://mcp.context7.com/mcp
  else claude mcp add --scope user --transport http context7 https://mcp.context7.com/mcp; fi
fi
if cli codex; then
  codex mcp remove playwright >/dev/null 2>&1 || true  # same
  codex mcp remove context7 >/dev/null 2>&1 || true
  if [ -n "$key" ]; then codex mcp add context7 -- npx -y "@upstash/context7-mcp@$CONTEXT7_MCP" --api-key "$key"
  else codex mcp add context7 -- npx -y "@upstash/context7-mcp@$CONTEXT7_MCP"; fi
fi
