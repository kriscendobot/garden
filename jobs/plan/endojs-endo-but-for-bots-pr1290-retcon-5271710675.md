---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1290-review-5271710675-chain
priority: urgent
role: fixer
posted_by: gardener
posted_at: 2026-09-21T23:44:42Z
---

---
handler-budget-role: review
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Wear the fixer role and retcon endojs/endo-but-for-bots PR 1290 after the mentat feedback pass completes. Use the retcon skill: reset and restage the complete PR net diff into coherent per-package commits, with yarn.lock alone in a final commit whose subject is exactly `chore: Update yarn.lock`. Preserve the net diff byte-for-byte, run all required invariant and local verification checks, push with force-with-lease/CAS discipline, and post the required top-level PR summary. Do not merge; the conductor child follows.
