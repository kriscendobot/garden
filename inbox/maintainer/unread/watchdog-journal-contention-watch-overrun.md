from_host: endolin-garden2-5bcdff64
from: watchdog:journal-contention-watch
sent_at: 2026-10-05T17:09:25Z
watchdog_key: journal-contention-watch-overrun
notice_count: 42
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-05T17:09:25Z
---
WATCHDOG notice — occurrence #42 (first seen 2026-10-04T05:15:32Z, latest 2026-10-05T17:09:25Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 42 times; this is ONE
coalesced notice that updates in place, not 42 messages. Latest detail:

Journal contention checker on endolin-garden2-5bcdff64 cannot finish a tick inside its 210s budget: deferred 14 of 1094 clone(s) on consecutive ticks.
