from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T15:27:14Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 69
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T15:27:14Z
---
WATCHDOG notice — occurrence #69 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T15:27:14Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 69 times; this is ONE
coalesced notice that updates in place, not 69 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790609246 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 2486s (since 2026-09-28T14:45:47Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 4343s (since 2026-09-28T14:14:50Z)
- kriscendobot/finbot: watcher ticking but cooldown for 4320s (since 2026-09-28T14:15:13Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 4300s (since 2026-09-28T14:15:33Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 4324s (since 2026-09-28T14:15:09Z)
- kriscendobot/endo: watcher ticking but cooldown for 4237s (since 2026-09-28T14:16:36Z)
- kriscendobot/garden: watcher ticking but cooldown for 3543s (since 2026-09-28T14:28:10Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3536s (since 2026-09-28T14:28:17Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2487s (since 2026-09-28T14:45:46Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2502s (since 2026-09-28T14:45:31Z)
