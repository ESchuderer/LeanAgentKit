# Pinned versions of every third-party install, sourced by lib.sh. Bump here, then rerun scripts/install.sh.
# Ponytail is pinned by commit in .claude-plugin/marketplace.json (Claude Code) and .agents/plugins/marketplace.json (Codex).
SKILLS_CLI=1.7.2        # https://github.com/vercel-labs/skills
ECC_SHA=5cc14d7c3155c7dcd4059c94b89df4b6303b7cd6  # https://github.com/affaan-m/ECC, global skills
ECC_UNIVERSAL=2.2.3     # Memory Vault CLI, https://www.npmjs.com/package/ecc-universal
RTK=v0.51.0             # https://github.com/rtk-ai/rtk/releases
CONTEXT7_MCP=4.3.0      # Codex stdio server; Claude Code uses the hosted HTTP server
CODEGRAPH=1.6.2         # https://github.com/colbymchenry/codegraph
OPENSPEC=1.14.1         # https://github.com/Fission-AI/OpenSpec
TYPESCRIPT=5.9.3        # last JS-based line ships lib/tsserver.js, which typescript-language-server needs; 7.x (Go) does not
TS_LANGSERVER=6.0.2     # typescript-language-server
PYRIGHT=1.1.414
SKILL_SCANNER=2.2.2     # https://github.com/cisco-ai-defense/skill-scanner, 90-check.sh
