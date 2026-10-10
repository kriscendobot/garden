from_host: endolin-garden2-5bcdff64
from: watchdog:comment-latency-watch
sent_at: 2026-10-10T02:03:52Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 2
first_seen: 2026-10-09T18:02:55Z
last_seen: 2026-10-10T02:03:52Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-09T18:02:55Z, latest 2026-10-10T02:03:52Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment watchers on endolin-garden2-5bcdff64 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 1 source(s); they post no acknowledgments while it holds.
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3697s (since 2026-10-10T01:02:14Z)
