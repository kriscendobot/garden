from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T16:40:37Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 6
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T16:40:37Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T16:40:37Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 15 source(s); they post no acknowledgments while it holds.
- kriscendobot/cosgov: watcher ticking but offline-journal for 2772s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 2860s (since 2026-09-26T15:52:39Z)
- kriscendobot/test262: watcher ticking but offline-journal for 2783s (since 2026-09-26T15:53:56Z)
- kriscendobot/moddable: watcher ticking but offline-journal for 2947s (since 2026-09-26T15:51:12Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 2843s (since 2026-09-26T15:52:56Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 2794s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 2863s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 2795s (since 2026-09-26T15:53:44Z)
- kriscendobot/proposal-compartments: watcher ticking but offline-journal for 2830s (since 2026-09-26T15:53:09Z)
- kriscendobot/list: watcher ticking but offline-journal for 2792s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 2832s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 2846s (since 2026-09-26T15:52:53Z)
watcher ticking but offline-journal for 2768s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 2902s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 2836s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 3128s (since 2026-09-26T15:48:11Z)
