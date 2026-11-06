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
doomed_at: 2026-11-05T12:43:26Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-05T12:43:26Z
---

---
posted_at: 2026-11-05T12:22:04Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
scripts/jobs/deploy-garden.sh:507 records an rc=1 suite failure with an empty diagnostic, as the 2026-11-05T11:51:31Z rejection shows. When a captured suite output is empty, append deterministic invocation and gate-state context so deploy failures remain actionable.
