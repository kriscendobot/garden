from_host: endolin-garden-ece02cb4
from: gauntlet:kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-halted
msg_key: kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-halted
notice_count: 1
first_seen: 2026-10-10T21:14:12Z
last_seen: 2026-10-10T21:14:13Z
sent_at: 2026-10-10T21:14:13Z
---
Gauntlet kriscendobot-minion-town-pr94-screen-6098638b-gauntlet HALTED: stage 'kriscendobot-minion-town-pr94-screen-6098638b-gauntlet-panel-6' (panel) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.

Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 6/6 · cost so far: $12.26

To resume: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion-town-pr94-screen-6098638b-gauntlet panel --iteration 6 --add-rounds 2
--add-rounds 2 grants 2 more panel/fix round(s): max_iterations 6 -> 8 (N is yours to choose).
