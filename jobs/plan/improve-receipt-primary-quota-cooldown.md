---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-10-02T21:43:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-10-02T21:43:06Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh
scripts/jobs/receipt-watcher.sh:97-101 treats GitHub primary-quota stderr as a generic transient and logs a 300s cooldown, though the 2026-10-02T19:45:23Z warning was followed by a 3599s primary-quota latch.
Detect primary quota before the generic transient path, request `api_primary_quota_secs`, and log the actual full quota cooldown; add a regression test for the adopted `gh_api_retry` latch.
