---
gate: orchestrated
orchestrated_by: muster-improve-fixes-r2-20261106
priority: normal
posted_by: liaison
posted_at: 2026-11-06T02:08:55Z
---

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

