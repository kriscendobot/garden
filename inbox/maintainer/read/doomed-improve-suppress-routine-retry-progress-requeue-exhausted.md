from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-06T03:13:55Z
doom_base: improve-suppress-routine-retry-progress
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-06T03:13:55Z
last_seen: 2026-11-06T03:13:55Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/improve-suppress-routine-retry-progress; it stays HELD until a human promotes it
(promote-plan.sh improve-suppress-routine-retry-progress) or removes it, so nothing is lost.
Original job base: improve-suppress-routine-retry-progress

--- original job body ---
---
posted_at: 2026-11-06T02:51:35Z
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1941 emits a journal progress entry for every ordinary job whose sole retry fails; three such routine reaper handoffs appeared at 02:23:56Z–02:34:15Z. Keep this state local and let the deterministic reaper report only its actual split or maintainer-surface disposition, preserving silent-until-error.
