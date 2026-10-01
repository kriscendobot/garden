from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T11:48:30Z
watchdog_key: journal-contention-watch-overrun
notice_count: 13
first_seen: 2026-10-01T04:12:22Z
last_seen: 2026-10-01T11:48:30Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-10-01T04:12:22Z, latest 2026-10-01T11:48:30Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 805 of 857 clone(s) on consecutive ticks.
