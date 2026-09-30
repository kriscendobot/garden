from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T18:22:17Z
watchdog_key: journal-contention-watch-overrun
notice_count: 3
first_seen: 2026-09-30T17:42:50Z
last_seen: 2026-09-30T18:22:17Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-30T17:42:50Z, latest 2026-09-30T18:22:17Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 51 of 734 clone(s) on consecutive ticks.
