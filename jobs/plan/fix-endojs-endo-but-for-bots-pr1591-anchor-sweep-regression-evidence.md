---
gate: go-ahead
priority: normal
role: fixer
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
doomed_at: 2026-11-17T09:03:56Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-17T09:03:56Z
---

---
posted_at: 2026-11-17T05:31:20Z
arc: endo-ocapn-background
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1591’s panel must-fix by proving the bwrap exit handler sweeps a retained process group when the leader exits while a member survives.
