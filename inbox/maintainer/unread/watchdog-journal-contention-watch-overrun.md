from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T05:12:12Z
watchdog_key: journal-contention-watch-overrun
notice_count: 53
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T05:12:12Z
---
WATCHDOG notice — occurrence #53 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T05:12:12Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 53 times; this is ONE
coalesced notice that updates in place, not 53 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1413 of 1413 clone(s) on consecutive ticks.
