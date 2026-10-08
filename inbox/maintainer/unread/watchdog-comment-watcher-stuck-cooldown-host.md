from_host: endolin-garden2-5bcdff64
from: watchdog:comment-latency-watch
sent_at: 2026-10-08T07:55:28Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 2
first_seen: 2026-10-08T05:55:52Z
last_seen: 2026-10-08T07:55:28Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-08T05:55:52Z, latest 2026-10-08T07:55:28Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment watchers on endolin-garden2-5bcdff64 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 12 source(s); they post no acknowledgments while it holds.
- kriscendobot/cosgov: watcher ticking but cooldown for 1852s (since 2026-10-08T07:24:36Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1843s (since 2026-10-08T07:24:45Z)
- kriscendobot/test262: watcher ticking but cooldown for 1856s (since 2026-10-08T07:24:32Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1849s (since 2026-10-08T07:24:39Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1881s (since 2026-10-08T07:24:07Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1872s (since 2026-10-08T07:24:16Z)
- kriscendobot/list: watcher ticking but cooldown for 1896s (since 2026-10-08T07:23:52Z)
- kriscendobot/garden: watcher ticking but cooldown for 1884s (since 2026-10-08T07:24:04Z)
watcher ticking but cooldown for 1808s (since 2026-10-08T07:25:20Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1875s (since 2026-10-08T07:24:13Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1819s (since 2026-10-08T07:25:09Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1894s (since 2026-10-08T07:23:54Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1849s (since 2026-10-08T07:24:39Z)
