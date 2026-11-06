---
withdrawn: true
withdrawn_reason: superseded by the -r2 child under muster-*-r2-20261106 (clean re-post; the doomed original was rejected on orchestration adoption)
withdrawn_by: liaison
withdrawn_at: 2026-11-06T02:08:06Z
withdrawn_from_gate: orchestrated
---

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
doomed_at: 2026-11-05T14:43:12Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-05T14:43:12Z
---

---
posted_at: 2026-11-05T14:21:39Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1941 records a second transient failure only as progress; four distinct jobs reached that state on `endolin-garden-ece02cb4` between 13:53:51Z and 14:13:28Z. Add a short-lived, host-local distinct-base burst detector that emits one deduplicated error and engages a bounded retry/claim cooldown for correlated second-attempt transient failures, while retaining the reaper as disposition owner.
