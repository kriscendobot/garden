from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T12:13:06Z
watchdog_key: journal-outage-stuck
notice_count: 27
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-28T12:13:06Z
---
WATCHDOG notice — occurrence #27 (first seen 2026-09-27T02:00:48Z, latest 2026-09-28T12:13:06Z).
The SAME condition (`journal-outage-stuck`) has now been observed 27 times; this is ONE
coalesced notice that updates in place, not 27 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 901s (limit 600s); skips this tick=1, trailing skips=1.
