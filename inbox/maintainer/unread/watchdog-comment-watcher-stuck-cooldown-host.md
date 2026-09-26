from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T16:51:28Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 8
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T16:51:28Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T16:51:28Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 12 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790441505 cursor-get 
- kriscendobot/cosgov: watcher ticking but offline-journal for 3388s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 3476s (since 2026-09-26T15:52:39Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 3383s (since 2026-09-26T15:54:12Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 3410s (since 2026-09-26T15:53:45Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 3411s (since 2026-09-26T15:53:44Z)
- kriscendobot/proposal-compartments: watcher ticking but offline-journal for 3446s (since 2026-09-26T15:53:09Z)
- kriscendobot/list: watcher ticking but offline-journal for 3408s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 3448s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 3384s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 3518s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 3452s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 3744s (since 2026-09-26T15:48:11Z)
