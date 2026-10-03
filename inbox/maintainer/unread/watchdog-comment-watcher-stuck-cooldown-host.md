from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-10-03T22:42:17Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 2
first_seen: 2026-10-03T06:41:59Z
last_seen: 2026-10-03T22:42:17Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-03T06:41:59Z, latest 2026-10-03T22:42:17Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 7 source(s); they post no acknowledgments while it holds.
- kriscendobot/test262: watcher ticking but cooldown for 3653s (since 2026-10-03T21:41:24Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3634s (since 2026-10-03T21:41:43Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3609s (since 2026-10-03T21:42:08Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3690s (since 2026-10-03T21:40:47Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3643s (since 2026-10-03T21:41:34Z)
- kriscendobot/garden: watcher ticking but cooldown for 3611s (since 2026-10-03T21:42:06Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3690s (since 2026-10-03T21:40:47Z)
