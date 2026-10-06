from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T12:08:09Z
watchdog_key: journal-contention-watch-overrun
notice_count: 67
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T12:08:09Z
---
WATCHDOG notice — occurrence #67 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T12:08:09Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 67 times; this is ONE
coalesced notice that updates in place, not 67 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=111 (clones=111, remedies=0, cleanup=0, notices=0) on consecutive ticks.
