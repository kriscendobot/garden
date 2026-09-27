from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T17:45:52Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 21
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T17:45:52Z
---
WATCHDOG notice — occurrence #21 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T17:45:52Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 21 times; this is ONE
coalesced notice that updates in place, not 21 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 9 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790531396 set-by=receipt:kriscendobot-ymax-e2e:journal prerequisite
journal-outage marker: 1790531218 cursor-get 
- kriscendobot/test262: watcher ticking but cooldown for 2864s (since 2026-09-27T16:57:50Z)
- kriscendobot/finbot: watcher ticking but cooldown for 5793s (since 2026-09-27T16:09:01Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2504s (since 2026-09-27T17:03:50Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 4000s (since 2026-09-27T16:38:54Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2508s (since 2026-09-27T17:03:46Z)
- kriscendobot/list: watcher ticking but cooldown for 3561s (since 2026-09-27T16:46:13Z)
- kriscendobot/garden: watcher ticking but cooldown for 2484s (since 2026-09-27T17:04:10Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2461s (since 2026-09-27T17:04:33Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2481s (since 2026-09-27T17:04:13Z)
