from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-08T22:13:22Z
doom_base: improve-byte-pressure-clone-recovery
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-08T22:13:22Z
last_seen: 2026-11-08T22:13:22Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-byte-pressure-clone-recovery; it stays HELD until a human promotes it
(promote-plan.sh improve-byte-pressure-clone-recovery) or removes it, so nothing is lost.
Original job base: improve-byte-pressure-clone-recovery

--- original job body ---
---
posted_at: 2026-11-08T21:51:26Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/state-clone-keeper.sh
At `scripts/jobs/state-clone-keeper.sh:237-248`, pressure detection measures only free inodes, while journal syncs repeatedly failed with `Out of diskspace` at 2026-11-08 21:34:40. Add a `df -P` byte-headroom sensor and block-pressure threshold, then run the existing conservative stale-clone recovery with tightened limits when either resource is scarce. If the keeper cannot sync under byte pressure, safely sweep only inactive unit-keyed clones after the existing idle/process/lock guards, never inbox clones whose board liveness cannot be read. Emit a deduplicated unrecovered byte-pressure alert with the measured capacity and clear it on recovery.
