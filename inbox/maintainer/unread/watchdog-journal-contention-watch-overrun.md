from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T02:15:05Z
watchdog_key: journal-contention-watch-overrun
notice_count: 15
first_seen: 2026-10-02T17:51:26Z
last_seen: 2026-10-03T02:15:05Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-10-02T17:51:26Z, latest 2026-10-03T02:15:05Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 970 of 1059 clone(s) on consecutive ticks.
