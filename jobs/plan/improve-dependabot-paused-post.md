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
doomed_at: 2026-11-16T11:13:07Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-16T11:13:07Z
---

---
posted_at: 2026-11-16T10:21:07Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
scripts/jobs/dependabot-watcher.sh:1056 discards post-job’s rc=78, then lines 1059-1071 misclassify the deliberate pause refusal as a lost post every tick. Preserve and recognize GARDEN_PAUSED_RC, suppress the retry warning, and skip the paused PR until its pause is lifted; the same false warning recurred from 09:28:28Z through 10:19:55Z.
