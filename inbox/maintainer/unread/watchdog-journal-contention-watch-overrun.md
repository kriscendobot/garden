from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-01T12:48:09Z
watchdog_key: journal-contention-watch-overrun
notice_count: 14
first_seen: 2026-10-01T04:12:22Z
last_seen: 2026-10-01T12:48:09Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-10-01T04:12:22Z, latest 2026-10-01T12:48:09Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 811 of 863 clone(s) on consecutive ticks.
