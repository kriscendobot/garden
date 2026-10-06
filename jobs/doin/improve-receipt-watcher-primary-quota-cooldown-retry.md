---
arc: garden-upkeep
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fixer job on the garden repo (kriscendobot/garden, main2). In `scripts/jobs/receipt-watcher.sh` (around lines 91-101), a GitHub primary-quota error is still handled as a generic transient with a 300s cooldown, even though GitHub enforces a 3599s primary-quota latch. Detect primary quota before the transient path, request `api_primary_quota_secs`, log the real cooldown, and add a regression test for the adopted `gh_api_retry` latch, matching how `comment-source-gh` already does it. This re-posts the parked `improve-receipt-primary-quota-cooldown`, which was doomed on the minion tier.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T16:38:27Z
