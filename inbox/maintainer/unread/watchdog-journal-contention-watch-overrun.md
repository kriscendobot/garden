from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T10:11:55Z
watchdog_key: journal-contention-watch-overrun
notice_count: 11
first_seen: 2026-09-30T04:16:26Z
last_seen: 2026-09-30T10:11:55Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-09-30T04:16:26Z, latest 2026-09-30T10:11:55Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 57 of 725 clone(s) on consecutive ticks.
