from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T10:22:32Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 15
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T10:22:32Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T10:22:32Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 1 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790504595 cursor-get 
- kriscendobot/garden: watcher ticking but cooldown for 1432s (since 2026-09-27T09:58:28Z)
