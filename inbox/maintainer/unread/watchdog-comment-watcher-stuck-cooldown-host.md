from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T19:50:28Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 26
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T19:50:28Z
---
WATCHDOG notice — occurrence #26 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T19:50:28Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 26 times; this is ONE
coalesced notice that updates in place, not 26 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 7 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790538906 set-by=receipt:kriscendobot-list:journal prerequisite
journal-outage marker: 1790538633 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 1759s (since 2026-09-27T19:21:09Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 4056s (since 2026-09-27T18:42:52Z)
- kriscendobot/list: watcher ticking but cooldown for 4015s (since 2026-09-27T18:43:33Z)
- kriscendobot/endo: watcher ticking but cooldown for 1744s (since 2026-09-27T19:21:24Z)
- kriscendobot/garden: watcher ticking but cooldown for 1766s (since 2026-09-27T19:21:02Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 9975s (since 2026-09-27T17:04:13Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1764s (since 2026-09-27T19:21:04Z)
