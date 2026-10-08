---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/review-docket.sh
scripts/jobs/review-docket.sh:296-323 serially fetches unbounded open PR metadata, causing garden-review-docket-reconcile to exceed its 900s limit at 2026-10-08T08:12:21Z. Add a deadline-aware bounded batch with per-request timeouts and resumable cursor state, so one slow or large docket cannot make the periodic recovery fail whole.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-08T08:22:16Z
