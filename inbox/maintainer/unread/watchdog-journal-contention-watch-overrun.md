from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-05T11:18:31Z
watchdog_key: journal-contention-watch-overrun
notice_count: 37
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-05T11:18:31Z
---
WATCHDOG notice — occurrence #37 (first seen 2026-10-04T05:15:32Z, latest 2026-10-05T11:18:31Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 37 times; this is ONE
coalesced notice that updates in place, not 37 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 1041 of 1066 clone(s) on consecutive ticks.
