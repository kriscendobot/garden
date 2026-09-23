from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/1
sent_at: 2026-07-29T11:35:47Z
watchdog_key: handler-budget-overrun-endojs-endo-but-for-bots-pr836-review-ee46b083
notice_count: 2
first_seen: 2026-07-29T02:46:44Z
last_seen: 2026-07-29T11:35:47Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-07-29T02:46:44Z, latest 2026-07-29T11:35:47Z).
The SAME condition (`handler-budget-overrun-endojs-endo-but-for-bots-pr836-review-ee46b083`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

gardener job 'endojs-endo-but-for-bots-pr836-review-ee46b083' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=3064s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be POISONED after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic poison report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
