---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 3
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-16T07:43:03Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-16T07:43:03Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Shepherd https://github.com/endojs/endo-but-for-bots/pull/340 (feat(daemon): OCapN-Noise transport for daemon-to-daemon) to green.

State verified 2026-08-16: OPEN, non-draft, mergeStateStatus UNSTABLE, head f081208e1 (updated 08-15). Exactly one check fails: test (24.x, ubuntu-latest). Everything else passes 27/28.

This is the transport root of the OCapN stack (340 -> 684 -> 688 -> 693), so getting it green unblocks the restack. Diagnose and fix the single failing job; do not rewrite unrelated history.
