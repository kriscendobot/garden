from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T17:39:54Z
watchdog_key: journal-contention-watch-overrun
notice_count: 29
first_seen: 2026-10-03T05:02:31Z
last_seen: 2026-10-03T17:39:54Z
---
WATCHDOG notice — occurrence #29 (first seen 2026-10-03T05:02:31Z, latest 2026-10-03T17:39:54Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 29 times; this is ONE
coalesced notice that updates in place, not 29 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 32 of 903 clone(s) on consecutive ticks.
