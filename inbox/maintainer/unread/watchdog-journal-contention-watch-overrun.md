from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T21:55:34Z
watchdog_key: journal-contention-watch-overrun
notice_count: 8
first_seen: 2026-10-02T17:51:26Z
last_seen: 2026-10-02T21:55:34Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-10-02T17:51:26Z, latest 2026-10-02T21:55:34Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 79 of 1050 clone(s) on consecutive ticks.
