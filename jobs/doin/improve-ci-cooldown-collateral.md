---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
scripts/jobs/ci-watcher.sh:514 misclassifies a `NOT ISSUED` refusal from the transient receipt latch as a fresh primary-quota exhaustion, evidenced by the 2026-10-25T04:29:34Z paired warnings.
Detect the host-shared admission-refusal diagnostic before quota classification and silently discard the incomplete source result, as the existing collateral-latch handling intends.
Add a regression fixture for a non-primary receipt-owned cooldown to ensure CI emits no second quota warning and issues no request.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-25T04:51:21Z
