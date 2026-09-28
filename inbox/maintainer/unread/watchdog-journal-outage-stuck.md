from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T00:37:19Z
watchdog_key: journal-outage-stuck
notice_count: 18
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-28T00:37:19Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-09-27T02:00:48Z, latest 2026-09-28T00:37:19Z).
The SAME condition (`journal-outage-stuck`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 901s (limit 600s); skips this tick=2, trailing skips=2.
