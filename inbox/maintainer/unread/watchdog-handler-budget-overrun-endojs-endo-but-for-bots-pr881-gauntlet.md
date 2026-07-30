from_host: endolin-garden2-5bcdff64
from: watchdog:fireworker/1
sent_at: 2026-07-30T23:08:32Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet
notice_count: 2
first_seen: 2026-07-29T04:18:30Z
last_seen: 2026-07-30T23:08:32Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-07-29T04:18:30Z, latest 2026-07-30T23:08:32Z).
The SAME condition (`handler-budget-overrun-endojs-endo-but-for-bots-pr881-gauntlet`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

gardener job 'endojs-endo-but-for-bots-pr881-gauntlet' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2401s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
