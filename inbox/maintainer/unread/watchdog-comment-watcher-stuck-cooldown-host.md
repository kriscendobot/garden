from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T03:10:47Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 42
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T03:10:47Z
---
WATCHDOG notice — occurrence #42 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T03:10:47Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 42 times; this is ONE
coalesced notice that updates in place, not 42 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790565082 cursor-get 
- kriscendobot/test262: watcher ticking but cooldown for 1426s (since 2026-09-28T02:47:00Z)
- kriscendobot/endo: watcher ticking but cooldown for 1738s (since 2026-09-28T02:41:48Z)
- kriscendobot/garden: watcher ticking but cooldown for 1424s (since 2026-09-28T02:47:02Z)
watcher ticking but cooldown for 6529s (since 2026-09-28T01:21:57Z)
