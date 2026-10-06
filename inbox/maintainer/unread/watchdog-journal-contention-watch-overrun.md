from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T03:01:53Z
watchdog_key: journal-contention-watch-overrun
notice_count: 51
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T03:01:53Z
---
WATCHDOG notice — occurrence #51 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T03:01:53Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 51 times; this is ONE
coalesced notice that updates in place, not 51 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1365 of 1402 clone(s) on consecutive ticks.
