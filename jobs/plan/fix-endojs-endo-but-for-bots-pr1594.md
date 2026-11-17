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
doomed_at: 2026-11-17T03:13:15Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-17T03:13:15Z
---

---
posted_at: 2026-11-17T00:46:45Z
arc: unallocated
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix endojs/endo-but-for-bots PR #1594’s current zizmor and test-xs failures to unblock the M3 daemon-to-manager rename.
