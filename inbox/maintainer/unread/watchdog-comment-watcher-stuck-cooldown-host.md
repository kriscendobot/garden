from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T09:16:54Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 56
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T09:16:54Z
---
WATCHDOG notice — occurrence #56 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T09:16:54Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 56 times; this is ONE
coalesced notice that updates in place, not 56 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790587040 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 1297s (since 2026-09-28T08:55:16Z)
- kriscendobot/test262: watcher ticking but cooldown for 3953s (since 2026-09-28T08:11:00Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1722s (since 2026-09-28T08:48:11Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1712s (since 2026-09-28T08:48:21Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2062s (since 2026-09-28T08:42:31Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1294s (since 2026-09-28T08:55:19Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1708s (since 2026-09-28T08:48:25Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1719s (since 2026-09-28T08:48:14Z)
- kriscendobot/garden: watcher ticking but cooldown for 1647s (since 2026-09-28T08:49:26Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1715s (since 2026-09-28T08:48:18Z)
