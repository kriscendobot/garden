---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-set.sh
Treat a timed-out shared cursor-IO lock as temporary unavailability (with one bounded diagnostic), not a fatal failure; the lock wedge blocked cursor advancement across watchers for five minutes and contributed to repeated retry noise. Remove the misleading manual lock-file deletion advice and add safe holder/recovery diagnostics.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T07:21:57Z
