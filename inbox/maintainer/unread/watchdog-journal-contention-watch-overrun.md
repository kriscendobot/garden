from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T17:03:14Z
watchdog_key: journal-contention-watch-overrun
notice_count: 22
first_seen: 2026-09-30T04:16:26Z
last_seen: 2026-09-30T17:03:14Z
---
WATCHDOG notice — occurrence #22 (first seen 2026-09-30T04:16:26Z, latest 2026-09-30T17:03:14Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 22 times; this is ONE
coalesced notice that updates in place, not 22 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 28 of 771 clone(s) on consecutive ticks.
