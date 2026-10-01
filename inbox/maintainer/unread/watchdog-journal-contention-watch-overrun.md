from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T06:07:34Z
watchdog_key: journal-contention-watch-overrun
notice_count: 4
first_seen: 2026-10-01T04:12:22Z
last_seen: 2026-10-01T06:07:34Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-01T04:12:22Z, latest 2026-10-01T06:07:34Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 832 of 832 clone(s) on consecutive ticks.
