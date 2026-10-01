from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T16:23:23Z
watchdog_key: journal-contention-watch-overrun
notice_count: 20
first_seen: 2026-10-01T04:12:22Z
last_seen: 2026-10-01T16:23:23Z
---
WATCHDOG notice — occurrence #20 (first seen 2026-10-01T04:12:22Z, latest 2026-10-01T16:23:23Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 20 times; this is ONE
coalesced notice that updates in place, not 20 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 887 of 887 clone(s) on consecutive ticks.
