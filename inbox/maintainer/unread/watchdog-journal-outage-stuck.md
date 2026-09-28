from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T02:57:26Z
watchdog_key: journal-outage-stuck
notice_count: 20
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-28T02:57:26Z
---
WATCHDOG notice — occurrence #20 (first seen 2026-09-27T02:00:48Z, latest 2026-09-28T02:57:26Z).
The SAME condition (`journal-outage-stuck`) has now been observed 20 times; this is ONE
coalesced notice that updates in place, not 20 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 602s (limit 600s); skips this tick=3, trailing skips=3.
