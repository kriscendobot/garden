---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/watchman.sh
scripts/jobs/watchman.sh:45 resolves the local `main2` ref although the service observes the deployed worktree HEAD; at 12:04:54–12:05:16 this missing ref crashed watchman. Resolve `HEAD` for the local deployed SHA (with the existing bounded retry), retaining `origin/main2` only as the upstream comparison, and add a detached-HEAD regression test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T12:23:18Z
