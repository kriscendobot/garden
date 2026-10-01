from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-10-01T00:37:57Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 2
first_seen: 2026-09-30T20:38:38Z
last_seen: 2026-10-01T00:37:57Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-30T20:38:38Z, latest 2026-10-01T00:37:57Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 4 source(s); they post no acknowledgments while it holds.
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3678s (since 2026-09-30T23:36:33Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3671s (since 2026-09-30T23:36:40Z)
- kriscendobot/endo: watcher ticking but cooldown for 3615s (since 2026-09-30T23:37:36Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3652s (since 2026-09-30T23:36:59Z)
