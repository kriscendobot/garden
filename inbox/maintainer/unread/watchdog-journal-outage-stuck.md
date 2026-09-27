from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-27T10:01:19Z
watchdog_key: journal-outage-stuck
notice_count: 7
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-27T10:01:19Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-27T02:00:48Z, latest 2026-09-27T10:01:19Z).
The SAME condition (`journal-outage-stuck`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 901s (limit 600s); skips this tick=1, trailing skips=1.
