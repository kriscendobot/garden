---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
Defect: scripts/jobs/deadline-nudge.sh:450 treats Git’s journal2 ref compare-and-swap rejection as `server-reject`; 2026-10-05T20:18:32Z shows `cannot lock ref ... is at ... but expected ...`, a concurrent-update race. Classify this diagnostic as retryable/lost-race, re-sync and recompute the nudge batch, and add a regression test so a legitimate concurrent journal push neither drops warnings nor raises a repair alert.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-05T20:20:58Z
