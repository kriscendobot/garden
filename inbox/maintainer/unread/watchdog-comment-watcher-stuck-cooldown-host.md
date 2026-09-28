from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T00:15:47Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 36
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T00:15:47Z
---
WATCHDOG notice — occurrence #36 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T00:15:47Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 36 times; this is ONE
coalesced notice that updates in place, not 36 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 11 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790554620 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 6829s (since 2026-09-27T22:21:57Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1370s (since 2026-09-27T23:52:56Z)
- kriscendobot/test262: watcher ticking but cooldown for 3588s (since 2026-09-27T23:15:58Z)
- kriscendobot/finbot: watcher ticking but cooldown for 7530s (since 2026-09-27T22:10:16Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3897s (since 2026-09-27T23:10:49Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1356s (since 2026-09-27T23:53:10Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1323s (since 2026-09-27T23:53:43Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1329s (since 2026-09-27T23:53:37Z)
- kriscendobot/endo: watcher ticking but cooldown for 7176s (since 2026-09-27T22:16:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 6459s (since 2026-09-27T22:28:07Z)
watcher ticking but cooldown for 2750s (since 2026-09-27T23:29:56Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1329s (since 2026-09-27T23:53:37Z)
