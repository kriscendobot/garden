from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T16:56:22Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 9
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T16:56:22Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T16:56:22Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 16 source(s); they post no acknowledgments while it holds.
- kriscendobot/cosgov: watcher ticking but offline-journal for 3682s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 3770s (since 2026-09-26T15:52:39Z)
- kriscendobot/test262: watcher ticking but offline-journal for 3693s (since 2026-09-26T15:53:56Z)
- kriscendobot/moddable: watcher ticking but offline-journal for 3857s (since 2026-09-26T15:51:12Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 3753s (since 2026-09-26T15:52:56Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 3677s (since 2026-09-26T15:54:12Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 3704s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 3773s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 3705s (since 2026-09-26T15:53:44Z)
- kriscendobot/proposal-compartments: watcher ticking but offline-journal for 3740s (since 2026-09-26T15:53:09Z)
- kriscendobot/list: watcher ticking but offline-journal for 3702s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 3742s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 3756s (since 2026-09-26T15:52:53Z)
watcher ticking but offline-journal for 3678s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 3812s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 3746s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 4038s (since 2026-09-26T15:48:11Z)
