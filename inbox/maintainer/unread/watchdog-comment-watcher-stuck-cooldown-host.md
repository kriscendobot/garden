from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T22:21:12Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 32
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T22:21:12Z
---
WATCHDOG notice — occurrence #32 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T22:21:12Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 32 times; this is ONE
coalesced notice that updates in place, not 32 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 4 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790547900 set-by=receipt:kriscendobot-cosgov:journal prerequisite
journal-outage marker: 1790547709 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 3741s (since 2026-09-27T21:18:27Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1818s (since 2026-09-27T21:50:30Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1418s (since 2026-09-27T21:57:10Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1440s (since 2026-09-27T21:56:48Z)
