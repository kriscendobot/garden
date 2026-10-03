from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T18:19:26Z
watchdog_key: journal-contention-watch-overrun
notice_count: 31
first_seen: 2026-10-03T05:02:31Z
last_seen: 2026-10-03T18:19:26Z
---
WATCHDOG notice — occurrence #31 (first seen 2026-10-03T05:02:31Z, latest 2026-10-03T18:19:26Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 31 times; this is ONE
coalesced notice that updates in place, not 31 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 911 of 911 clone(s) on consecutive ticks.
