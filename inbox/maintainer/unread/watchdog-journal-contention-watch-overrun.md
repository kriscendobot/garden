from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T06:25:05Z
watchdog_key: journal-contention-watch-overrun
notice_count: 19
first_seen: 2026-10-01T20:53:24Z
last_seen: 2026-10-02T06:25:05Z
---
WATCHDOG notice — occurrence #19 (first seen 2026-10-01T20:53:24Z, latest 2026-10-02T06:25:05Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 19 times; this is ONE
coalesced notice that updates in place, not 19 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 27 of 965 clone(s) on consecutive ticks.
