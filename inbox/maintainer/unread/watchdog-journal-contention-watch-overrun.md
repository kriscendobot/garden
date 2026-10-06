from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T20:13:27Z
watchdog_key: journal-contention-watch-overrun
notice_count: 82
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T20:13:27Z
---
WATCHDOG notice — occurrence #82 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T20:13:27Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 82 times; this is ONE
coalesced notice that updates in place, not 82 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=1454 (clones=1454, remedies=0, cleanup=0, notices=0) on consecutive ticks.
