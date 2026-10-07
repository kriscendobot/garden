---
withdrawn: true
withdrawn_reason: moot: fixed on main2 by c3f1b02 (receipt-watcher latches GitHub primary quota for the full window); maintainer muster go-ahead
withdrawn_by: liaison
withdrawn_at: 2026-10-07T21:29:31Z
withdrawn_from_gate: go-ahead
---

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
failure_classification: deterministic
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-10-03T05:23:09Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-10-03T05:23:09Z
---

---
tier: minion
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-10-03T04:56:45Z cleared=none -->

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh
scripts/jobs/receipt-watcher.sh:97-101 treats GitHub primary-quota stderr as a generic transient and logs a 300s cooldown, though the 2026-10-02T19:45:23Z warning was followed by a 3599s primary-quota latch.
Detect primary quota before the generic transient path, request `api_primary_quota_secs`, and log the actual full quota cooldown; add a regression test for the adopted `gh_api_retry` latch.
