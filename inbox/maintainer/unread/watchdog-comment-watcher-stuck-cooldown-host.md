from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T22:51:08Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 33
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T22:51:08Z
---
WATCHDOG notice — occurrence #33 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T22:51:08Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 33 times; this is ONE
coalesced notice that updates in place, not 33 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790549738 set-by=receipt:kriscendobot-ymax-e2e:journal prerequisite
journal-outage marker: 1790549553 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 1730s (since 2026-09-27T22:21:57Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1362s (since 2026-09-27T22:28:05Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1749s (since 2026-09-27T22:21:38Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2431s (since 2026-09-27T22:10:16Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2406s (since 2026-09-27T22:10:41Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3617s (since 2026-09-27T21:50:30Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1744s (since 2026-09-27T22:21:43Z)
- kriscendobot/endo: watcher ticking but cooldown for 2077s (since 2026-09-27T22:16:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 1360s (since 2026-09-27T22:28:07Z)
watcher ticking but cooldown for 2092s (since 2026-09-27T22:15:55Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1727s (since 2026-09-27T22:22:00Z)
