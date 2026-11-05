from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T06:07:07Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 29
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T06:07:07Z
---
WATCHDOG notice — occurrence #29 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T06:07:07Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 29 times; this is ONE
coalesced notice that updates in place, not 29 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793861786 set-by=receipt:kriscendobot-list:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793861786 set-by=mirror-closer:primary-quota
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 4560s (since 2026-11-05T04:51:04Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 8543s (since 2026-11-05T03:44:41Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 4561s (since 2026-11-05T04:51:03Z)
