from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T05:38:06Z
watchdog_key: journal-contention-watch-overrun
notice_count: 54
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T05:38:06Z
---
WATCHDOG notice — occurrence #54 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T05:38:06Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 54 times; this is ONE
coalesced notice that updates in place, not 54 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 54 of 1413 clone(s) on consecutive ticks.
