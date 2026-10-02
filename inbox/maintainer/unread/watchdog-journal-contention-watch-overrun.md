from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T02:19:34Z
watchdog_key: journal-contention-watch-overrun
notice_count: 11
first_seen: 2026-10-01T20:53:24Z
last_seen: 2026-10-02T02:19:34Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-10-01T20:53:24Z, latest 2026-10-02T02:19:34Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 53 of 946 clone(s) on consecutive ticks.
