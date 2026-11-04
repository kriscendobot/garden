from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T11:24:33Z
watchdog_key: journal-outage-stuck
notice_count: 2
first_seen: 2026-11-04T10:18:44Z
last_seen: 2026-11-04T11:24:33Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-04T10:18:44Z, latest 2026-11-04T11:24:33Z).
The SAME condition (`journal-outage-stuck`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 2403s (limit 600s); skips this tick=7, trailing skips=7.
