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
doomed_at: 2026-11-06T01:43:09Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-06T01:43:09Z
---

---
posted_at: 2026-11-06T01:21:17Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:6598 issues requests unserialized after its 60-second admission-lock wait, observed for review-metadata fanout at Nov 06 00:54:12. Defer the request with a transient result (and bounded retry on a later tick) instead, preserving the cooldown single-flight invariant when a sibling holds the lock.
