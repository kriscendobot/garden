from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T02:55:49Z
watchdog_key: journal-outage-stuck
notice_count: 2
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-27T02:55:49Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-27T02:00:48Z, latest 2026-09-27T02:55:49Z).
The SAME condition (`journal-outage-stuck`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 601s (limit 600s); skips this tick=1, trailing skips=1.
