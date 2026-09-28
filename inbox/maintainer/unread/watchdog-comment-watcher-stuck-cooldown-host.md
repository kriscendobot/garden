from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T10:02:10Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 58
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T10:02:10Z
---
WATCHDOG notice — occurrence #58 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T10:02:10Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 58 times; this is ONE
coalesced notice that updates in place, not 58 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 2 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790589963 set-by=receipt:kriscendobot-cosgov:journal prerequisite
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 4425s (since 2026-09-28T08:48:25Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 4436s (since 2026-09-28T08:48:14Z)
