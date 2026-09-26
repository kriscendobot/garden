from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T17:16:19Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 13
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T17:16:19Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T17:16:19Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790443215 set-by=receipt:kriscendobot-ymax-stdio-mcp:journal prerequisite
- kriscendobot/test262: watcher ticking but offline-journal for 4896s (since 2026-09-26T15:53:56Z)
- kriscendobot/list: watcher ticking but offline-journal for 4905s (since 2026-09-26T15:53:47Z)
- kriscendobot/garden: watcher ticking but offline-journal for 4881s (since 2026-09-26T15:54:11Z)
