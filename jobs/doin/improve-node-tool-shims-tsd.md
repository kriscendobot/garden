---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/install-node-tool-shims.sh
Add a runtime-relative `tsd` shim and test it. The prescribed SES verification failed in a warm-cache worktree because `tsd` was omitted from the shared shim installer.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-26T16:21:03Z
