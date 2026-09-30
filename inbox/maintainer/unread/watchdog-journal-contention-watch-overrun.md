from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T03:06:31Z
watchdog_key: journal-contention-watch-overrun
notice_count: 10
first_seen: 2026-09-29T21:30:46Z
last_seen: 2026-09-30T03:06:31Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-09-29T21:30:46Z, latest 2026-09-30T03:06:31Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 582 of 633 clone(s) on consecutive ticks.
