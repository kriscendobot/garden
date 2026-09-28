from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T04:56:39Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 46
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T04:56:39Z
---
WATCHDOG notice — occurrence #46 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T04:56:39Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 46 times; this is ONE
coalesced notice that updates in place, not 46 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 8 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790571618 set-by=receipt:kriscendobot-garden:journal prerequisite
journal-outage marker: 1790571394 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 4342s (since 2026-09-28T03:43:51Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3653s (since 2026-09-28T03:55:20Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 6635s (since 2026-09-28T03:05:38Z)
- kriscendobot/list: watcher ticking but cooldown for 3261s (since 2026-09-28T04:01:52Z)
- kriscendobot/endo: watcher ticking but cooldown for 1426s (since 2026-09-28T04:32:27Z)
- kriscendobot/garden: watcher ticking but cooldown for 3250s (since 2026-09-28T04:02:03Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3271s (since 2026-09-28T04:01:42Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3640s (since 2026-09-28T03:55:33Z)
