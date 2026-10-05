from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-05T01:12:59Z
watchdog_key: journal-contention-watch-overrun
notice_count: 24
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-05T01:12:59Z
---
WATCHDOG notice — occurrence #24 (first seen 2026-10-04T05:15:32Z, latest 2026-10-05T01:12:59Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 24 times; this is ONE
coalesced notice that updates in place, not 24 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 56 of 1041 clone(s) on consecutive ticks.
