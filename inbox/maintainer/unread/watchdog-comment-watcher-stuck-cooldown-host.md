from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T09:57:49Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 66
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T09:57:49Z
---
WATCHDOG notice — occurrence #66 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T09:57:49Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 66 times; this is ONE
coalesced notice that updates in place, not 66 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 2 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793874014 set-by=receipt:kriscendobot-endo:PR source:primary-quota <- receipt:kriscendobot-minion.town:receipt generate
gh-api GraphQL-only marker: expiry=1793874014 set-by=mirror-closer:primary-quota
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2253s (since 2026-11-05T09:20:15Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 2255s (since 2026-11-05T09:20:13Z)
