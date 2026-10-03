from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T12:04:35Z
watchdog_key: journal-contention-watch-overrun
notice_count: 17
first_seen: 2026-10-03T05:02:31Z
last_seen: 2026-10-03T12:04:35Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-10-03T05:02:31Z, latest 2026-10-03T12:04:35Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 55 of 1166 clone(s) on consecutive ticks.
