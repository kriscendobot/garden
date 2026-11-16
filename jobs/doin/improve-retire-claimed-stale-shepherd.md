---
posted_at: 2026-11-16T08:51:13Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
`scripts/jobs/ci-watcher.sh:940` revalidates only unclaimed `todo` shepherds; the claimed `endojs-endo-but-for-bots-pr1636-shepherd` then exhausted its retry after CI needed no agent completion (`entries/2026/11/16/083604Z-progress-gardener-798580.md:7`). Extend the sweep to atomically retire a same-claim `doin` auto-shepherd when the rollup is definitively no longer red, preserving claim-race checks and writing the normal completion record.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-16T08:51:47Z
