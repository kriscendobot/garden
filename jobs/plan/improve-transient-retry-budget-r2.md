---
gate: go-ahead
priority: normal
role: builder
tier: mentor
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
doomed_at: 2026-11-07T02:43:18Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T02:43:18Z
---

---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:55Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-06T05:16:27Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/reaper.sh
Defect: `scripts/jobs/reaper.sh:1091` increments the plain-exit counter for a `reap-now` transient unless the fleet brake is engaged, exhausting an innocent job’s sole retry; `design-daemon-git-remotes-extended-transports` hit rc=75 again after that charged retry at 2026-11-05T19:33:37Z.
Treat non-outage `reap-now` transient cycles as non-attributable: preserve the prior retry count, requeue with bounded backoff, and reserve split-eligible parking for deterministic or otherwise attributable failures.
