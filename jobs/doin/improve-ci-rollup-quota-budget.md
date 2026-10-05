---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
scripts/jobs/ci-watcher.sh:540-568 issues an unbounded GraphQL rollup read for every recently active bot PR; the 2026-10-05T17:59:32Z sweep exhausted the primary GraphQL quota.
Add a configurable per-tick rollup budget with a persisted fair cursor, stop quietly when spent, and prioritize unvisited eligible PRs next tick so CI monitoring remains reliable without repeatedly reaching quota.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-05T18:21:07Z
