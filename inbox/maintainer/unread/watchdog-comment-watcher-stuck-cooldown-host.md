from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-30T02:31:11Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 2
first_seen: 2026-09-29T22:35:40Z
last_seen: 2026-09-30T02:31:11Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-29T22:35:40Z, latest 2026-09-30T02:31:11Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 12 source(s); they post no acknowledgments while it holds.
- kriscendobot/ocapn: watcher ticking but cooldown for 3562s (since 2026-09-30T01:31:48Z)
- kriscendobot/test262: watcher ticking but cooldown for 3628s (since 2026-09-30T01:30:42Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3569s (since 2026-09-30T01:31:41Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3649s (since 2026-09-30T01:30:21Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3649s (since 2026-09-30T01:30:21Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3610s (since 2026-09-30T01:31:00Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3658s (since 2026-09-30T01:30:12Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3598s (since 2026-09-30T01:31:12Z)
- kriscendobot/list: watcher ticking but cooldown for 3600s (since 2026-09-30T01:31:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 3586s (since 2026-09-30T01:31:24Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3658s (since 2026-09-30T01:30:12Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3634s (since 2026-09-30T01:30:36Z)
