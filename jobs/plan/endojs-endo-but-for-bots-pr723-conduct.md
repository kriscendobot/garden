---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: requeue-exhausted
poison_count: 1
requeue_cycles: 5
deadline_overruns: 0
poisoned_at: 2026-07-29T10:43:04Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-29T10:43:04Z
tier: minion
model: gpt-5.6-terra
fallback-tier: minion
dispatch: automatic
---

---
role: conductor
---

Merge endojs/endo-but-for-bots PR #723 after its current maintainer approval is present. The PR is already undrafted; do not change that state. Review feedback 4803487425 was addressed at b746656b538933e381e5de62f532a62ed671dc96, and all checks were green at dispatch. Use the conductor procedure to verify current head, CI, and approval, then merge.
