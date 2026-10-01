from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T21:49:32Z
watchdog_key: journal-contention-watch-overrun
notice_count: 3
first_seen: 2026-10-01T20:53:24Z
last_seen: 2026-10-01T21:49:32Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-01T20:53:24Z, latest 2026-10-01T21:49:32Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 53 of 912 clone(s) on consecutive ticks.
