from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-05T13:43:44Z
watchdog_key: journal-contention-watch-overrun
notice_count: 39
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-05T13:43:44Z
---
WATCHDOG notice — occurrence #39 (first seen 2026-10-04T05:15:32Z, latest 2026-10-05T13:43:44Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 39 times; this is ONE
coalesced notice that updates in place, not 39 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 1068 of 1076 clone(s) on consecutive ticks.
