from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T16:21:32Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 2
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T16:21:32Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T16:21:32Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 14 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790439703 cursor-get 
- kriscendobot/cosgov: watcher ticking but offline-journal for 1586s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 1674s (since 2026-09-26T15:52:39Z)
- kriscendobot/moddable: watcher ticking but offline-journal for 1761s (since 2026-09-26T15:51:12Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 1657s (since 2026-09-26T15:52:56Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 1581s (since 2026-09-26T15:54:12Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 1608s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 1677s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 1609s (since 2026-09-26T15:53:44Z)
- kriscendobot/list: watcher ticking but offline-journal for 1606s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 1646s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 1582s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 1716s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 1650s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 1942s (since 2026-09-26T15:48:11Z)
