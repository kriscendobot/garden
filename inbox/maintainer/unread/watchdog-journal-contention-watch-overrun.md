from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T21:13:36Z
watchdog_key: journal-contention-watch-overrun
notice_count: 2
first_seen: 2026-10-01T20:53:24Z
last_seen: 2026-10-01T21:13:36Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-01T20:53:24Z, latest 2026-10-01T21:13:36Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 874 of 910 clone(s) on consecutive ticks.
