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
failure_classification: deterministic
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-27T23:36:17Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-27T23:36:17Z
---

---
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fix the failing zizmor check on endojs/endo-but-for-bots PR #1356, branch build/hardened-url-shim, and restore CI to green.
