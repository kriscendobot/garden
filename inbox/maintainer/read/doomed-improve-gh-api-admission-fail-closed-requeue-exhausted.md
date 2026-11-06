from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T01:43:18Z
doom_base: improve-gh-api-admission-fail-closed
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T01:43:18Z
last_seen: 2026-11-06T01:43:18Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-gh-api-admission-fail-closed; it stays HELD until a human promotes it
(promote-plan.sh improve-gh-api-admission-fail-closed) or removes it, so nothing is lost.
Original job base: improve-gh-api-admission-fail-closed

--- original job body ---
---
posted_at: 2026-11-06T01:21:17Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:6598 issues requests unserialized after its 60-second admission-lock wait, observed for review-metadata fanout at Nov 06 00:54:12. Defer the request with a transient result (and bounded retry on a later tick) instead, preserving the cooldown single-flight invariant when a sibling holds the lock.
