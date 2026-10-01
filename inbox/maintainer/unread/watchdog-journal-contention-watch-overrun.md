from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T02:07:01Z
watchdog_key: journal-contention-watch-overrun
notice_count: 10
first_seen: 2026-09-30T20:43:07Z
last_seen: 2026-10-01T02:07:01Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-09-30T20:43:07Z, latest 2026-10-01T02:07:01Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 793 of 793 clone(s) on consecutive ticks.
