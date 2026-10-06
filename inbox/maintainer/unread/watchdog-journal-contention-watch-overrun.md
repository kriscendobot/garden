from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T12:47:46Z
watchdog_key: journal-contention-watch-overrun
notice_count: 68
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T12:47:46Z
---
WATCHDOG notice — occurrence #68 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T12:47:46Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 68 times; this is ONE
coalesced notice that updates in place, not 68 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=1388 (clones=1388, remedies=0, cleanup=0, notices=0) on consecutive ticks.
