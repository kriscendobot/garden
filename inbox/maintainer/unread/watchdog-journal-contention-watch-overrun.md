from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T15:58:56Z
watchdog_key: journal-contention-watch-overrun
notice_count: 19
first_seen: 2026-10-01T04:12:22Z
last_seen: 2026-10-01T15:58:56Z
---
WATCHDOG notice — occurrence #19 (first seen 2026-10-01T04:12:22Z, latest 2026-10-01T15:58:56Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 19 times; this is ONE
coalesced notice that updates in place, not 19 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 52 of 884 clone(s) on consecutive ticks.
