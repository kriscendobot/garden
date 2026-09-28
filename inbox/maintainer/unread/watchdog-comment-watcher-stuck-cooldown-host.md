from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T07:56:40Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 52
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T07:56:40Z
---
WATCHDOG notice — occurrence #52 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T07:56:40Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 52 times; this is ONE
coalesced notice that updates in place, not 52 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 11 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790582429 set-by=receipt:kriscendobot-cosgov:journal prerequisite
journal-outage marker: 1790582195 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 1784s (since 2026-09-28T07:26:50Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 4038s (since 2026-09-28T06:49:16Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1349s (since 2026-09-28T07:34:05Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1783s (since 2026-09-28T07:26:51Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1727s (since 2026-09-28T07:27:47Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1835s (since 2026-09-28T07:25:59Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1774s (since 2026-09-28T07:27:00Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1785s (since 2026-09-28T07:26:49Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1811s (since 2026-09-28T07:26:23Z)
- kriscendobot/garden: https://github.com/kriscendobot/garden/issues/114#issuecomment-5864051232 (age=8782s; heartbeat=cooldown)
watcher ticking but cooldown for 1870s (since 2026-09-28T07:25:24Z)
watcher ticking but cooldown for 4014s (since 2026-09-28T06:49:40Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1793s (since 2026-09-28T07:26:41Z)
