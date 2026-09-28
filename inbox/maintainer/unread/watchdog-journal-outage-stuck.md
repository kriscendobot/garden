from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T16:23:22Z
watchdog_key: journal-outage-stuck
notice_count: 30
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-28T16:23:22Z
---
WATCHDOG notice — occurrence #30 (first seen 2026-09-27T02:00:48Z, latest 2026-09-28T16:23:22Z).
The SAME condition (`journal-outage-stuck`) has now been observed 30 times; this is ONE
coalesced notice that updates in place, not 30 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 601s (limit 600s); skips this tick=2, trailing skips=2.
