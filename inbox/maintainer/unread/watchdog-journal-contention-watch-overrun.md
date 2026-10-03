from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T04:09:58Z
watchdog_key: journal-contention-watch-overrun
notice_count: 16
first_seen: 2026-10-02T17:51:26Z
last_seen: 2026-10-03T04:09:58Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-10-02T17:51:26Z, latest 2026-10-03T04:09:58Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1082 of 1082 clone(s) on consecutive ticks.
