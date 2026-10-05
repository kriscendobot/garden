---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
Defect: scripts/jobs/deadline-nudge.sh:450 treats Git’s journal2 ref compare-and-swap rejection as `server-reject`; 2026-10-05T20:18:32Z shows `cannot lock ref ... is at ... but expected ...`, a concurrent-update race. Classify this diagnostic as retryable/lost-race, re-sync and recompute the nudge batch, and add a regression test so a legitimate concurrent journal push neither drops warnings nor raises a repair alert.
