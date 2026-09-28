from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T05:46:04Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 48
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T05:46:04Z
---
WATCHDOG notice — occurrence #48 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T05:46:04Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 48 times; this is ONE
coalesced notice that updates in place, not 48 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 11 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790574631 set-by=receipt:kriscendobot-list:journal prerequisite
journal-outage marker: 1790574382 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 1698s (since 2026-09-28T05:17:46Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1434s (since 2026-09-28T05:22:10Z)
- kriscendobot/test262: watcher ticking but cooldown for 3225s (since 2026-09-28T04:52:19Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1749s (since 2026-09-28T05:16:55Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1294s (since 2026-09-28T05:24:30Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1680s (since 2026-09-28T05:18:04Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2891s (since 2026-09-28T04:57:53Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1295s (since 2026-09-28T05:24:29Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1742s (since 2026-09-28T05:17:02Z)
- kriscendobot/endo: watcher ticking but cooldown for 2153s (since 2026-09-28T05:10:11Z)
- kriscendobot/garden: watcher ticking but cooldown for 1362s (since 2026-09-28T05:23:22Z)
watcher ticking but cooldown for 3686s (since 2026-09-28T04:44:38Z)
