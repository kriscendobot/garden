from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T21:57:24Z
watchdog_key: journal-contention-watch-overrun
notice_count: 4
first_seen: 2026-09-30T20:43:07Z
last_seen: 2026-09-30T21:57:24Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-09-30T20:43:07Z, latest 2026-09-30T21:57:24Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 728 of 754 clone(s) on consecutive ticks.
