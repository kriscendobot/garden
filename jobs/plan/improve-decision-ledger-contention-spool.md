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
doomed_at: 2026-11-05T18:13:13Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-05T18:13:13Z
---

---
posted_at: 2026-11-05T17:51:35Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/decision-append.sh
Defect: `scripts/jobs/decision-append.sh:108` drops decisions when its optional 5-second clone lock wait is busy; the reaper lost `schedule-plain-retry` at 17:24:39Z and `mark-split-eligible` at 17:35:39Z.
Persist failed decision rows in a host-local durable spool and flush them under the ledger lock on a later successful invocation, retaining fail-open behavior for controllers.
Add coverage for lock contention followed by recovery to verify both rows reach the ledger once.
