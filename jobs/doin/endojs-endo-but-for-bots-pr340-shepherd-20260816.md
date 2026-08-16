---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Shepherd https://github.com/endojs/endo-but-for-bots/pull/340 (feat(daemon): OCapN-Noise transport for daemon-to-daemon) to green.

State verified 2026-08-16: OPEN, non-draft, mergeStateStatus UNSTABLE, head f081208e1 (updated 08-15). Exactly one check fails: test (24.x, ubuntu-latest). Everything else passes 27/28.

This is the transport root of the OCapN stack (340 -> 684 -> 688 -> 693), so getting it green unblocks the restack. Diagnose and fix the single failing job; do not rewrite unrelated history.

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: hermit
  tier: 
  provider: local
  model: 
  claimed_at: 2026-08-16T06:33:38Z
