from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T21:10:48Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 29
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T21:10:48Z
---
WATCHDOG notice — occurrence #29 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T21:10:48Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 29 times; this is ONE
coalesced notice that updates in place, not 29 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 6 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790543709 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
- kriscendobot/finbot: watcher ticking but cooldown for 3590s (since 2026-09-27T20:10:42Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 8860s (since 2026-09-27T18:42:52Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 5447s (since 2026-09-27T19:39:45Z)
- kriscendobot/list: watcher ticking but cooldown for 2564s (since 2026-09-27T20:27:48Z)
- kriscendobot/garden: watcher ticking but cooldown for 2140s (since 2026-09-27T20:34:52Z)
watcher ticking but cooldown for 2562s (since 2026-09-27T20:27:50Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 14779s (since 2026-09-27T17:04:13Z)
