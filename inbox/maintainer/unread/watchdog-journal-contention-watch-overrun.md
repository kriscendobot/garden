from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-04T07:00:41Z
watchdog_key: journal-contention-watch-overrun
notice_count: 5
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-04T07:00:41Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-10-04T05:15:32Z, latest 2026-10-04T07:00:41Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 957 of 975 clone(s) on consecutive ticks.
