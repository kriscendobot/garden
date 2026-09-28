from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T13:17:08Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 65
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T13:17:08Z
---
WATCHDOG notice — occurrence #65 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T13:17:08Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 65 times; this is ONE
coalesced notice that updates in place, not 65 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 7 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790601702 set-by=receipt:kriscendobot-ymax-e2e:journal prerequisite
journal-outage marker: 1790601438 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 1700s (since 2026-09-28T12:48:48Z)
- kriscendobot/test262: watcher ticking but cooldown for 2142s (since 2026-09-28T12:41:26Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2136s (since 2026-09-28T12:41:32Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3986s (since 2026-09-28T12:10:42Z)
- kriscendobot/endo: watcher ticking but cooldown for 3940s (since 2026-09-28T12:11:28Z)
- kriscendobot/garden: watcher ticking but cooldown for 2136s (since 2026-09-28T12:41:32Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2135s (since 2026-09-28T12:41:33Z)
