from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T21:05:45Z
watchdog_key: journal-contention-watch-overrun
notice_count: 7
first_seen: 2026-10-02T17:51:26Z
last_seen: 2026-10-02T21:05:45Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-10-02T17:51:26Z, latest 2026-10-02T21:05:45Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1037 of 1037 clone(s) on consecutive ticks.
