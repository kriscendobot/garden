from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T15:07:31Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 17
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T15:07:31Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T15:07:31Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 2 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790521926 set-by=receipt:kriscendobot-garden:journal prerequisite
journal-outage marker: 1790521751 cursor-get 
- kriscendobot/list: watcher ticking but cooldown for 1743s (since 2026-09-27T14:38:28Z)
- kriscendobot/garden: watcher ticking but cooldown for 1785s (since 2026-09-27T14:37:46Z)
