from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T13:21:52Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 16
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T13:21:52Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T13:21:52Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 2 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790515584 set-by=receipt:kriscendobot-minion.town:journal prerequisite
journal-outage marker: 1790515418 cursor-get 
- kriscendobot/minion.town: watcher ticking but cooldown for 1543s (since 2026-09-27T12:56:09Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1542s (since 2026-09-27T12:56:10Z)
