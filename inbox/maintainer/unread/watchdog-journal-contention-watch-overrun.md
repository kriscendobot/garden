from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T15:42:42Z
watchdog_key: journal-contention-watch-overrun
notice_count: 75
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T15:42:42Z
---
WATCHDOG notice — occurrence #75 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T15:42:42Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 75 times; this is ONE
coalesced notice that updates in place, not 75 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=1384 (clones=1384, remedies=0, cleanup=0, notices=0) on consecutive ticks.
