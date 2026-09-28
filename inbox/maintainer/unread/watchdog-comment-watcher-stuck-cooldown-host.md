from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T15:02:25Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 68
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T15:02:25Z
---
WATCHDOG notice — occurrence #68 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T15:02:25Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 68 times; this is ONE
coalesced notice that updates in place, not 68 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 11 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790607800 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 2855s (since 2026-09-28T14:14:50Z)
- kriscendobot/test262: watcher ticking but cooldown for 2800s (since 2026-09-28T14:15:45Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2832s (since 2026-09-28T14:15:13Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2812s (since 2026-09-28T14:15:33Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2832s (since 2026-09-28T14:15:13Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2836s (since 2026-09-28T14:15:09Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2836s (since 2026-09-28T14:15:09Z)
- kriscendobot/list: watcher ticking but cooldown for 2756s (since 2026-09-28T14:16:29Z)
- kriscendobot/endo: watcher ticking but cooldown for 2749s (since 2026-09-28T14:16:36Z)
- kriscendobot/garden: watcher ticking but cooldown for 2055s (since 2026-09-28T14:28:10Z)
watcher ticking but cooldown for 2834s (since 2026-09-28T14:15:11Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2048s (since 2026-09-28T14:28:17Z)
