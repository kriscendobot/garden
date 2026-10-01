from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T08:43:28Z
watchdog_key: journal-contention-watch-overrun
notice_count: 7
first_seen: 2026-10-01T04:12:22Z
last_seen: 2026-10-01T08:43:28Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-10-01T04:12:22Z, latest 2026-10-01T08:43:28Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 53 of 838 clone(s) on consecutive ticks.
