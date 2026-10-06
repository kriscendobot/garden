from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T13:02:22Z
watchdog_key: journal-contention-watch-overrun
notice_count: 69
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T13:02:22Z
---
WATCHDOG notice — occurrence #69 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T13:02:22Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 69 times; this is ONE
coalesced notice that updates in place, not 69 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=1430 (clones=1430, remedies=0, cleanup=0, notices=0) on consecutive ticks.
