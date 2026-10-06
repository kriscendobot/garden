from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T09:17:13Z
watchdog_key: journal-contention-watch-overrun
notice_count: 61
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T09:17:13Z
---
WATCHDOG notice — occurrence #61 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T09:17:13Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 61 times; this is ONE
coalesced notice that updates in place, not 61 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=1372 (clones=1372, remedies=0, cleanup=0, notices=0) on consecutive ticks.
