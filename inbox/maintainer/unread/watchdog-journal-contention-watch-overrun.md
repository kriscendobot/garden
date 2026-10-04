from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-04T23:17:11Z
watchdog_key: journal-contention-watch-overrun
notice_count: 20
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-04T23:17:11Z
---
WATCHDOG notice — occurrence #20 (first seen 2026-10-04T05:15:32Z, latest 2026-10-04T23:17:11Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 20 times; this is ONE
coalesced notice that updates in place, not 20 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 1033 of 1033 clone(s) on consecutive ticks.
