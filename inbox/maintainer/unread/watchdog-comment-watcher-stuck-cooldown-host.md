from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T16:35:37Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 5
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T16:35:37Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T16:35:37Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
- kriscendobot/test262: watcher ticking but offline-journal for 2496s (since 2026-09-26T15:53:56Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 2556s (since 2026-09-26T15:52:56Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 2480s (since 2026-09-26T15:54:12Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 2507s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 2576s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 2508s (since 2026-09-26T15:53:44Z)
- kriscendobot/endo: watcher ticking but offline-journal for 2545s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 2559s (since 2026-09-26T15:52:53Z)
watcher ticking but offline-journal for 2481s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 2615s (since 2026-09-26T15:51:57Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 2841s (since 2026-09-26T15:48:11Z)
