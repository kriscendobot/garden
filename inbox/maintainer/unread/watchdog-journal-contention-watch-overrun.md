from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T00:55:01Z
watchdog_key: journal-contention-watch-overrun
notice_count: 48
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T00:55:01Z
---
WATCHDOG notice — occurrence #48 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T00:55:01Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 48 times; this is ONE
coalesced notice that updates in place, not 48 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 15 of 1123 clone(s) on consecutive ticks.
