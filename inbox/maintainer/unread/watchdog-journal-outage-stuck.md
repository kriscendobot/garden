from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-09-28T10:12:52Z
watchdog_key: journal-outage-stuck
notice_count: 26
first_seen: 2026-09-27T02:00:48Z
last_seen: 2026-09-28T10:12:52Z
---
WATCHDOG notice — occurrence #26 (first seen 2026-09-27T02:00:48Z, latest 2026-09-28T10:12:52Z).
The SAME condition (`journal-outage-stuck`) has now been observed 26 times; this is ONE
coalesced notice that updates in place, not 26 messages. Latest detail:

Journal outage latch stuck on endolin-garden-ece02cb4 for 900s (limit 600s); skips this tick=3, trailing skips=3.
