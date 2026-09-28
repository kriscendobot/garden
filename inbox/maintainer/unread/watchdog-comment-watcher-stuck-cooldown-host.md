from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T12:51:48Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 64
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T12:51:48Z
---
WATCHDOG notice — occurrence #64 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T12:51:48Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 64 times; this is ONE
coalesced notice that updates in place, not 64 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
- kriscendobot/ocapn: watcher ticking but cooldown for 4676s (since 2026-09-28T11:33:51Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3538s (since 2026-09-28T11:52:49Z)
- kriscendobot/finbot: watcher ticking but cooldown for 5684s (since 2026-09-28T11:17:03Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1650s (since 2026-09-28T12:24:17Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2469s (since 2026-09-28T12:10:38Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2465s (since 2026-09-28T12:10:42Z)
- kriscendobot/list: watcher ticking but cooldown for 10071s (since 2026-09-28T10:03:56Z)
- kriscendobot/endo: watcher ticking but cooldown for 2419s (since 2026-09-28T12:11:28Z)
- kriscendobot/garden: watcher ticking but cooldown for 2022s (since 2026-09-28T12:18:05Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1648s (since 2026-09-28T12:24:19Z)
