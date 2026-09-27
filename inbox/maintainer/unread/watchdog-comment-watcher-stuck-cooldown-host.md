from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T20:45:47Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 28
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T20:45:47Z
---
WATCHDOG notice — occurrence #28 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T20:45:47Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 28 times; this is ONE
coalesced notice that updates in place, not 28 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790542202 set-by=receipt:kriscendobot-ymax-stdio-mcp:journal prerequisite
journal-outage marker: 1790541983 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 5071s (since 2026-09-27T19:21:09Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3954s (since 2026-09-27T19:39:46Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2098s (since 2026-09-27T20:10:42Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 7368s (since 2026-09-27T18:42:52Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3171s (since 2026-09-27T19:52:49Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 4382s (since 2026-09-27T19:32:38Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3955s (since 2026-09-27T19:39:45Z)
- kriscendobot/endo: watcher ticking but cooldown for 5056s (since 2026-09-27T19:21:24Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3926s (since 2026-09-27T19:40:14Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 5076s (since 2026-09-27T19:21:04Z)
