---
withdrawn: true
withdrawn_reason: target endojs/endo-but-for-bots#600 (Ironhorse/xs2rust debugger) is MERGED; the three BreakpointTable parity nits would need re-filing against current llm if they survived the merge (2026-09-01 muster)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:56:06Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 1
doomed_at: 2026-08-19T02:33:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-19T02:33:06Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
endojs/endo-but-for-bots PR #600 (Ironhorse/xs2rust debugger): fix the three `BreakpointTable` parity nits — missing `line == 0 && id == 0` guard, the un-ported `start` pseudo-breakpoint, and a doc reference to a nonexistent `"unhandled"` pseudo-breakpoint.
