from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T08:21:41Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 53
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T08:21:41Z
---
WATCHDOG notice — occurrence #53 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T08:21:41Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 53 times; this is ONE
coalesced notice that updates in place, not 53 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 7 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790583944 set-by=receipt:kriscendobot-cosgov:journal prerequisite
journal-outage marker: 1790583754 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 3291s (since 2026-09-28T07:26:50Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3290s (since 2026-09-28T07:26:51Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3234s (since 2026-09-28T07:27:47Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3292s (since 2026-09-28T07:26:49Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3318s (since 2026-09-28T07:26:23Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2519s (since 2026-09-28T07:39:42Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3300s (since 2026-09-28T07:26:41Z)
