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
doomed_at: 2026-11-05T13:43:16Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-05T13:43:16Z
---

---
posted_at: 2026-11-05T13:21:24Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/issue-status-pass.sh
scripts/jobs/issue-status-pass.sh:211 repeatedly exhausts the tick before the source read (12:51:55Z, 13:17:05Z, 13:20:22Z). Read and trust-filter the source before expensive board snapshot work, reserving its configured timeout from the pass budget; then build the board only after a successful source read.
