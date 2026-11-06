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
doomed_at: 2026-11-06T03:13:21Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-06T03:13:21Z
---

---
posted_at: 2026-11-06T02:51:35Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1941 emits a journal progress entry for every ordinary job whose sole retry fails; three such routine reaper handoffs appeared at 02:23:56Z–02:34:15Z. Keep this state local and let the deterministic reaper report only its actual split or maintainer-surface disposition, preserving silent-until-error.
