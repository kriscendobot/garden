---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/review-docket-reconcile.sh
scripts/jobs/review-docket-reconcile.sh:10 propagates the expected retryable rc=75, producing a failed systemd unit at 2026-10-14T21:18:03 although the next reconcile succeeded. Normalize `GARDEN_OFFLINE_RC` to a clean timer exit while retaining the bounded-retry log; preserve non-transient exits as failures.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-14T21:36:05Z
