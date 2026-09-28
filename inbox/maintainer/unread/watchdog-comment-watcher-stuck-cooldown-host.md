from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T06:41:11Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 49
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T06:41:11Z
---
WATCHDOG notice — occurrence #49 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T06:41:11Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 49 times; this is ONE
coalesced notice that updates in place, not 49 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 8 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790577958 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
journal-outage marker: 1790577702 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 5004s (since 2026-09-28T05:17:46Z)
- kriscendobot/test262: watcher ticking but cooldown for 6531s (since 2026-09-28T04:52:19Z)
- kriscendobot/finbot: watcher ticking but cooldown for 5055s (since 2026-09-28T05:16:55Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 4986s (since 2026-09-28T05:18:04Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1405s (since 2026-09-28T06:17:45Z)
- kriscendobot/endo: watcher ticking but cooldown for 5459s (since 2026-09-28T05:10:11Z)
- kriscendobot/garden: watcher ticking but cooldown for 4668s (since 2026-09-28T05:23:22Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3180s (since 2026-09-28T05:48:10Z)
