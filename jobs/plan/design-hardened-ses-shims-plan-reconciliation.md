---
gate: deferred
priority: normal
role: designer
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
doomed_at: 2026-09-27T21:16:17Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-27T21:16:17Z
---

---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Reconcile the M2 hardened-url-shim and hardened-text-codecs-shim records for endojs/endo-but-for-bots: record upstream endojs/endo#3332 as URL completion and PR #1349 as the text-codecs work in progress, with current evidence and PR fields.

<!-- garden-annotation: key=hardened-url-shim-complete-endo3332 by=designer at=2026-09-27T21:55:17Z -->

The `hardened-url-shim` portion is complete: upstream endojs/endo#3332 merged on 2026-08-21, and endojs/endo-but-for-bots#1355 records the design-status evidence. Do not schedule or repeat URL implementation or reconciliation; only the text-codecs portion remains in scope.
