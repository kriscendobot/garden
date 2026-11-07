from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T06:53:15Z
doom_base: improve-minion-town-arc-press-breaker
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T06:53:15Z
last_seen: 2026-11-07T06:53:15Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-minion-town-arc-press-breaker; it stays HELD until a human promotes it
(promote-plan.sh improve-minion-town-arc-press-breaker) or removes it, so nothing is lost.
Original job base: improve-minion-town-arc-press-breaker

--- original job body ---
---
posted_at: 2026-11-07T05:52:24Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/minion-town-press-preflight.sh
Defect: `scripts/jobs/minion-town-press-preflight.sh:146` only recognizes completed idle reports, while the arc press exhausted its retry without completion at 2026-11-07T05:24:11Z and repeated `jobs/plan/minion-town-arc-press-*` failures remain invisible to its gate. Extend the gate for the arc schedule to recognize recent same-prefix `requeue-exhausted` plan records and park dispatch with one deduplicated maintainer notice. Wire that preflight into `schedules/minion-town-arc-press.md` so a repeatedly nonproductive supervisor does not consume another agent tick before its failure is resolved.
