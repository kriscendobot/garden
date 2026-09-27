from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T16:25:17Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 18
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T16:25:17Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T16:25:17Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790526565 set-by=receipt:kriscendobot-list:journal prerequisite
- kriscendobot/cosgov: watcher ticking but cooldown for 1673s (since 2026-09-27T15:57:24Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 2226s (since 2026-09-27T15:48:11Z)
- kriscendobot/test262: watcher ticking but cooldown for 2221s (since 2026-09-27T15:48:16Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1313s (since 2026-09-27T16:03:24Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2215s (since 2026-09-27T15:48:22Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1797s (since 2026-09-27T15:55:20Z)
- kriscendobot/endo: watcher ticking but cooldown for 1802s (since 2026-09-27T15:55:15Z)
- kriscendobot/garden: watcher ticking but cooldown for 2193s (since 2026-09-27T15:48:44Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1798s (since 2026-09-27T15:55:19Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2213s (since 2026-09-27T15:48:24Z)
