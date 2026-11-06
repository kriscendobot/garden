---
gate: orchestrated
orchestrated_by: muster-improve-fixes-20261106
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
doomed_at: 2026-11-05T20:13:18Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-05T20:13:18Z
---

---
posted_at: 2026-11-05T19:51:16Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/reaper.sh
Defect: `scripts/jobs/reaper.sh:1091` increments the plain-exit counter for a `reap-now` transient unless the fleet brake is engaged, exhausting an innocent job’s sole retry; `design-daemon-git-remotes-extended-transports` hit rc=75 again after that charged retry at 2026-11-05T19:33:37Z.
Treat non-outage `reap-now` transient cycles as non-attributable: preserve the prior retry count, requeue with bounded backoff, and reserve split-eligible parking for deterministic or otherwise attributable failures.
