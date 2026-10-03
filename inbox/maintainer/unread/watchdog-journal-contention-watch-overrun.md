from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T10:05:33Z
watchdog_key: journal-contention-watch-overrun
notice_count: 12
first_seen: 2026-10-03T05:02:31Z
last_seen: 2026-10-03T10:05:33Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-10-03T05:02:31Z, latest 2026-10-03T10:05:33Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 75 of 1157 clone(s) on consecutive ticks.
