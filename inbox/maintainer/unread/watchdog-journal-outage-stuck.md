from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T07:31:14Z
watchdog_key: journal-outage-stuck
notice_count: 6
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-27T07:31:14Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-27T02:00:48Z, latest 2026-09-27T07:31:14Z).
The SAME condition (`journal-outage-stuck`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 601s (limit 600s); skips this tick=1, trailing skips=1.
