from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T20:32:01Z
watchdog_key: journal-outage-stuck
notice_count: 13
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-27T20:32:01Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-09-27T02:00:48Z, latest 2026-09-27T20:32:01Z).
The SAME condition (`journal-outage-stuck`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 601s (limit 600s); skips this tick=3, trailing skips=3.
