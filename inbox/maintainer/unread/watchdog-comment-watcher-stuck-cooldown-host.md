from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T16:12:17Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 71
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T16:12:17Z
---
WATCHDOG notice — occurrence #71 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T16:12:17Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 71 times; this is ONE
coalesced notice that updates in place, not 71 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 2 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790612018 cursor-get 
- kriscendobot/moddable: watcher ticking but cooldown for 1771s (since 2026-09-28T15:42:46Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1389s (since 2026-09-28T15:49:08Z)
