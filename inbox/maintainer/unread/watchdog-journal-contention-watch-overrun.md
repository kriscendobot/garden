from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T15:07:02Z
watchdog_key: journal-contention-watch-overrun
notice_count: 18
first_seen: 2026-09-30T04:16:26Z
last_seen: 2026-09-30T15:07:02Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-09-30T04:16:26Z, latest 2026-09-30T15:07:02Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 734 of 734 clone(s) on consecutive ticks.
