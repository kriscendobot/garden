from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-30T08:42:54Z
watchdog_key: journal-contention-watch-overrun
notice_count: 9
first_seen: 2026-09-30T04:16:26Z
last_seen: 2026-09-30T08:42:54Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-09-30T04:16:26Z, latest 2026-09-30T08:42:54Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 33 of 706 clone(s) on consecutive ticks.
