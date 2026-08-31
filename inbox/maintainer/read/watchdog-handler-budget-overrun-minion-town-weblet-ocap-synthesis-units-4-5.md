from_host: endolin-garden2-5bcdff64
from: watchdog:cleric/2
sent_at: 2026-08-31T10:02:59Z
watchdog_key: handler-budget-overrun-minion-town-weblet-ocap-synthesis-units-4-5
notice_count: 2
first_seen: 2026-08-31T08:53:02Z
last_seen: 2026-08-31T10:02:59Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-08-31T08:53:02Z, latest 2026-08-31T10:02:59Z).
The SAME condition (`handler-budget-overrun-minion-town-weblet-ocap-synthesis-units-4-5`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

gardener job 'minion-town-weblet-ocap-synthesis-units-4-5' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=2401s ≈ handler-budget=2400s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle(s) without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler.
