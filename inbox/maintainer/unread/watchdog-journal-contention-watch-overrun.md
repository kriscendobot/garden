from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T04:47:07Z
watchdog_key: journal-contention-watch-overrun
notice_count: 52
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T04:47:07Z
---
WATCHDOG notice — occurrence #52 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T04:47:07Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 52 times; this is ONE
coalesced notice that updates in place, not 52 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1377 of 1411 clone(s) on consecutive ticks.
