---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
Use a cursor-specific timeout that permits cursor-get.sh’s bounded cursor-IO-lock wait plus grace, instead of killing it at the blanket 90-second stage limit. The repeated rc=124 cursor-read skips prevent the helper from returning its safe temporary-unavailable result, causing noisy retries; add a regression case for this timeout alignment.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T07:52:37Z
