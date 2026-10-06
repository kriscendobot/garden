from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T02:46:44Z
watchdog_key: journal-contention-watch-overrun
notice_count: 50
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T02:46:44Z
---
WATCHDOG notice — occurrence #50 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T02:46:44Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 50 times; this is ONE
coalesced notice that updates in place, not 50 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1361 of 1400 clone(s) on consecutive ticks.
