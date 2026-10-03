from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T06:45:59Z
watchdog_key: journal-contention-watch-overrun
notice_count: 6
first_seen: 2026-10-03T05:02:31Z
last_seen: 2026-10-03T06:45:59Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-10-03T05:02:31Z, latest 2026-10-03T06:45:59Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1117 of 1125 clone(s) on consecutive ticks.
