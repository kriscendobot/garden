from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T04:38:16Z
watchdog_key: journal-outage-stuck
notice_count: 22
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-28T04:38:16Z
---
WATCHDOG notice — occurrence #22 (first seen 2026-09-27T02:00:48Z, latest 2026-09-28T04:38:16Z).
The SAME condition (`journal-outage-stuck`) has now been observed 22 times; this is ONE
coalesced notice that updates in place, not 22 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 900s (limit 600s); skips this tick=2, trailing skips=2.
