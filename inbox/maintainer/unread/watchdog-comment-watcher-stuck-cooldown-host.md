from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T23:20:51Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 34
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T23:20:51Z
---
WATCHDOG notice — occurrence #34 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T23:20:51Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 34 times; this is ONE
coalesced notice that updates in place, not 34 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 11 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790551519 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
- kriscendobot/cosgov: watcher ticking but cooldown for 3533s (since 2026-09-27T22:21:57Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3165s (since 2026-09-27T22:28:05Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3552s (since 2026-09-27T22:21:38Z)
- kriscendobot/finbot: watcher ticking but cooldown for 4234s (since 2026-09-27T22:10:16Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2001s (since 2026-09-27T22:47:29Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3547s (since 2026-09-27T22:21:43Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1990s (since 2026-09-27T22:47:40Z)
- kriscendobot/list: watcher ticking but cooldown for 2000s (since 2026-09-27T22:47:30Z)
- kriscendobot/endo: watcher ticking but cooldown for 3880s (since 2026-09-27T22:16:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 3163s (since 2026-09-27T22:28:07Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3530s (since 2026-09-27T22:22:00Z)
