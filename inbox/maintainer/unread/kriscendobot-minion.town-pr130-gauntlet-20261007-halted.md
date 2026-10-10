from_host: endolin-garden-ece02cb4
from: gauntlet:kriscendobot-minion.town-pr130-gauntlet-20261007-halted
msg_key: kriscendobot-minion.town-pr130-gauntlet-20261007-halted
notice_count: 1
first_seen: 2026-10-10T10:14:11Z
last_seen: 2026-10-10T10:14:17Z
sent_at: 2026-10-10T10:14:17Z
---
Gauntlet kriscendobot-minion.town-pr130-gauntlet-20261007 HALTED: stage 'kriscendobot-minion.town-pr130-gauntlet-20261007-viability' (viability) failed 1 times and was doom-parked with doom_signature=requeue-exhausted. It was NOT retried because the record does not prove the underlying handler failure was transient (failure_classification=unknown); repeating an unknown failure would waste the stage budget.

To resume: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr130-gauntlet-20261007 panel --iteration 0 --add-rounds 2
--add-rounds 2 grants 2 more panel/fix round(s): max_iterations 6 -> 8 (N is yours to choose).
