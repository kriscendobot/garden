from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T07:02:19Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 40
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T07:02:19Z
---
WATCHDOG notice — occurrence #40 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T07:02:19Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 40 times; this is ONE
coalesced notice that updates in place, not 40 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 4 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793865712 set-by=receipt:kriscendobot-endo:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793865712 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3948s (since 2026-11-05T05:56:28Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3949s (since 2026-11-05T05:56:27Z)
- kriscendobot/garden: watcher ticking but cooldown for 3888s (since 2026-11-05T05:57:28Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 7873s (since 2026-11-05T04:51:03Z)
