from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T08:47:33Z
watchdog_key: journal-contention-watch-overrun
notice_count: 60
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T08:47:33Z
---
WATCHDOG notice — occurrence #60 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T08:47:33Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 60 times; this is ONE
coalesced notice that updates in place, not 60 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=1424 (clones=1424, remedies=0, cleanup=0, notices=0) on consecutive ticks.
