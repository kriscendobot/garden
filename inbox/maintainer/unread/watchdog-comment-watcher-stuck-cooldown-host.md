from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T20:20:30Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 27
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T20:20:30Z
---
WATCHDOG notice — occurrence #27 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T20:20:30Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 27 times; this is ONE
coalesced notice that updates in place, not 27 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 14 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790540685 set-by=receipt:kriscendobot-minion.town:journal prerequisite
journal-outage marker: 1790540533 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 3560s (since 2026-09-27T19:21:09Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1643s (since 2026-09-27T19:53:06Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2443s (since 2026-09-27T19:39:46Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 5857s (since 2026-09-27T18:42:52Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1662s (since 2026-09-27T19:52:47Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1660s (since 2026-09-27T19:52:49Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2871s (since 2026-09-27T19:32:38Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2444s (since 2026-09-27T19:39:45Z)
- kriscendobot/list: watcher ticking but cooldown for 5816s (since 2026-09-27T18:43:33Z)
- kriscendobot/endo: watcher ticking but cooldown for 3545s (since 2026-09-27T19:21:24Z)
- kriscendobot/garden: watcher ticking but cooldown for 3567s (since 2026-09-27T19:21:02Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2415s (since 2026-09-27T19:40:14Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 11776s (since 2026-09-27T17:04:13Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3565s (since 2026-09-27T19:21:04Z)
