---
withdrawn: true
withdrawn_reason: target endojs/endo-but-for-bots#1059 is MERGED; this doom-parked job can never advance (2026-09-01 muster)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:05:19Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
tier: mentor
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 2
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-28T14:43:03Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-28T14:43:03Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
https://github.com/endojs/endo-but-for-bots/pull/1059 ("feat(ironhorse)!: snapshot store seam") is
CONFLICTING/DIRTY against `llm` following the maintainer merging
https://github.com/endojs/endo-but-for-bots/pull/1046 just now. Rebase
onto current `llm`, resolve conflicts, push, and confirm CI.
