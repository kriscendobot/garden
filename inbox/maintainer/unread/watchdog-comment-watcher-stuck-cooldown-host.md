from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T18:15:30Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 22
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T18:15:30Z
---
WATCHDOG notice — occurrence #22 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T18:15:30Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 22 times; this is ONE
coalesced notice that updates in place, not 22 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 14 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790533211 set-by=receipt:kriscendobot-minion.town:journal prerequisite
journal-outage marker: 1790532925 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 2851s (since 2026-09-27T17:27:59Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 2017s (since 2026-09-27T17:41:53Z)
- kriscendobot/test262: watcher ticking but cooldown for 4660s (since 2026-09-27T16:57:50Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1296s (since 2026-09-27T17:53:54Z)
- kriscendobot/finbot: watcher ticking but cooldown for 7589s (since 2026-09-27T16:09:01Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 4300s (since 2026-09-27T17:03:50Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 5796s (since 2026-09-27T16:38:54Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2826s (since 2026-09-27T17:28:24Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 4304s (since 2026-09-27T17:03:46Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2780s (since 2026-09-27T17:29:10Z)
- kriscendobot/list: watcher ticking but cooldown for 5357s (since 2026-09-27T16:46:13Z)
- kriscendobot/endo: watcher ticking but cooldown for 1658s (since 2026-09-27T17:47:52Z)
- kriscendobot/garden: watcher ticking but cooldown for 2827s (since 2026-09-27T17:28:23Z)
watcher ticking but cooldown for 4280s (since 2026-09-27T17:04:10Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 4277s (since 2026-09-27T17:04:13Z)
