from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-06T09:38:23Z
watchdog_key: journal-contention-watch-overrun
notice_count: 62
first_seen: 2026-10-04T05:15:32Z
last_seen: 2026-10-06T09:38:23Z
---
WATCHDOG notice — occurrence #62 (first seen 2026-10-04T05:15:32Z, latest 2026-10-06T09:38:23Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 62 times; this is ONE
coalesced notice that updates in place, not 62 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred work=102 (clones=102, remedies=0, cleanup=0, notices=0) on consecutive ticks.
