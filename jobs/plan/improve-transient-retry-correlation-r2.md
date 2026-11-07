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
doomed_at: 2026-11-07T03:13:05Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T03:13:05Z
---

---
role: builder
tier: mentor
posted_at: 2026-11-06T02:08:55Z
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-07T02:48:43Z cleared=none -->

---
tier: mentor
token-budget: 100000
role: builder
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1941 records a second transient failure only as progress; four distinct jobs reached that state on `endolin-garden-ece02cb4` between 13:53:51Z and 14:13:28Z. Add a short-lived, host-local distinct-base burst detector that emits one deduplicated error and engages a bounded retry/claim cooldown for correlated second-attempt transient failures, while retaining the reaper as disposition owner.
