---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/minion-mcp-lib.sh
scripts/jobs/minion-mcp-lib.sh:139 builds dotted Codex MCP overrides that merge with a persisted `url`, yielding “url is not supported for stdio” and failing every attached Codex job (2026-10-03 04:52:19Z). Emit one complete replacement server table (and test it against a pre-existing URL configuration) so the stdio bridge cannot inherit incompatible HTTP fields.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-03T05:44:32Z
