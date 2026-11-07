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
doomed_at: 2026-11-07T19:03:12Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T19:03:12Z
---

---
posted_at: 2026-11-07T18:21:05Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/screen-delegated-prs.sh
scripts/jobs/screen-delegated-prs.sh:150 turns an exhausted journal CAS retry into `die`, causing the dedicated unit failure recorded at 2026-11-07T17:50:45Z. Preserve the bounded retry and failure streak, but classify contention/transient journal failures as a clean, deferred tick after recording the coalesced watchdog state; reserve nonzero exit for unrecoverable local faults.
