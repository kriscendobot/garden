from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T15:47:16Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 70
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T15:47:16Z
---
WATCHDOG notice — occurrence #70 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T15:47:16Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 70 times; this is ONE
coalesced notice that updates in place, not 70 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 1 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790610717 set-by=receipt:kriscendobot-list:journal prerequisite
journal-outage marker: 1790610548 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 5545s (since 2026-09-28T14:14:50Z)
