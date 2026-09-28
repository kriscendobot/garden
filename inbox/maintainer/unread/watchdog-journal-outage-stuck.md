from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T15:53:16Z
watchdog_key: journal-outage-stuck
notice_count: 29
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-28T15:53:16Z
---
WATCHDOG notice — occurrence #29 (first seen 2026-09-27T02:00:48Z, latest 2026-09-28T15:53:16Z).
The SAME condition (`journal-outage-stuck`) has now been observed 29 times; this is ONE
coalesced notice that updates in place, not 29 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 601s (limit 600s); skips this tick=5, trailing skips=5.
