from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T01:50:45Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 39
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T01:50:45Z
---
WATCHDOG notice — occurrence #39 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T01:50:45Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 39 times; this is ONE
coalesced notice that updates in place, not 39 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 8 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790560239 cursor-get 
- kriscendobot/test262: watcher ticking but cooldown for 3295s (since 2026-09-28T00:55:50Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2436s (since 2026-09-28T01:10:09Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1720s (since 2026-09-28T01:22:05Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 4050s (since 2026-09-28T00:43:15Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 4055s (since 2026-09-28T00:43:10Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1364s (since 2026-09-28T01:28:01Z)
- kriscendobot/list: watcher ticking but cooldown for 3296s (since 2026-09-28T00:55:49Z)
- kriscendobot/garden: watcher ticking but cooldown for 3290s (since 2026-09-28T00:55:55Z)
watcher ticking but cooldown for 1728s (since 2026-09-28T01:21:57Z)
