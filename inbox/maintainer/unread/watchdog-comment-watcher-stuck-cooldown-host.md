from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T19:05:32Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 24
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T19:05:32Z
---
WATCHDOG notice — occurrence #24 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T19:05:32Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 24 times; this is ONE
coalesced notice that updates in place, not 24 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
- kriscendobot/cosgov: watcher ticking but cooldown for 1405s (since 2026-09-27T18:42:07Z)
- kriscendobot/test262: watcher ticking but cooldown for 1299s (since 2026-09-27T18:43:53Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1314s (since 2026-09-27T18:43:38Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1360s (since 2026-09-27T18:42:52Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 8798s (since 2026-09-27T16:38:54Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2079s (since 2026-09-27T18:30:53Z)
- kriscendobot/list: watcher ticking but cooldown for 1319s (since 2026-09-27T18:43:33Z)
- kriscendobot/endo: watcher ticking but cooldown for 1405s (since 2026-09-27T18:42:07Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 7279s (since 2026-09-27T17:04:13Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2133s (since 2026-09-27T18:29:59Z)
