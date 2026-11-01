---
posted_at: 2026-11-01T17:54:26Z
arc: minion-town-claude-api
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build job on endojs/endo-but-for-bots: land the next implementation slice of the endo-claude-agents-capability design (the successor child-agent factory design in #1558). Stack it on the newest merged or open claude-agents slice (#1560, #1593, #1596) and keep the PR draft until the gauntlet runs. Add the next missing piece of the single-use credential lease, durable revocation and fail-closed restart path, with tests. Check `journal/jobs/` first so this does not duplicate `build-endo-child-agent-factory-slice-2`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T17:56:34Z
