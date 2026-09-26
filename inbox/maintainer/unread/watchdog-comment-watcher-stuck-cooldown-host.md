from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T16:25:57Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 3
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T16:25:57Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T16:25:57Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 15 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790439973 cursor-get 
- kriscendobot/cosgov: watcher ticking but offline-journal for 1871s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 1959s (since 2026-09-26T15:52:39Z)
- kriscendobot/test262: watcher ticking but offline-journal for 1882s (since 2026-09-26T15:53:56Z)
- kriscendobot/moddable: watcher ticking but offline-journal for 2046s (since 2026-09-26T15:51:12Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 1942s (since 2026-09-26T15:52:56Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 1893s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 1962s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 1894s (since 2026-09-26T15:53:44Z)
- kriscendobot/proposal-compartments: watcher ticking but offline-journal for 1929s (since 2026-09-26T15:53:09Z)
- kriscendobot/list: watcher ticking but offline-journal for 1891s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 1931s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 1945s (since 2026-09-26T15:52:53Z)
watcher ticking but offline-journal for 1867s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 2001s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 1935s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 2227s (since 2026-09-26T15:48:11Z)
