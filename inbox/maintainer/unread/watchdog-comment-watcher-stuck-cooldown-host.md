from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T07:02:09Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 39
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T07:02:09Z
---
WATCHDOG notice — occurrence #39 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T07:02:09Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 39 times; this is ONE
coalesced notice that updates in place, not 39 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793865712 set-by=receipt:kriscendobot-endo:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793865712 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3925s (since 2026-11-05T05:56:28Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3926s (since 2026-11-05T05:56:27Z)
- kriscendobot/garden: watcher ticking but cooldown for 3865s (since 2026-11-05T05:57:28Z)
