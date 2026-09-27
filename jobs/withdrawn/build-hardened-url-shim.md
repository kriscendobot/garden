---
withdrawn: true
withdrawn_reason: Upstream implementation merged as endojs/endo#3332 on 2026-08-21; duplicate implementation work is moot.
withdrawn_by: designer
withdrawn_at: 2026-09-27T21:54:32Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: builder
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: deterministic
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-27T19:36:19Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-27T19:36:19Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build the M2 `hardened-url-shim` design in `endojs/endo-but-for-bots` on a `master`-based branch, reconciling the vetted URL/URLSearchParams SES shim and opening a draft implementation PR if work remains.
