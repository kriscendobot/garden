from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-17T08:24:06Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 24
first_seen: 2026-11-13T06:01:28Z
last_seen: 2026-11-17T08:24:06Z
---
WATCHDOG notice — occurrence #24 (first seen 2026-11-13T06:01:28Z, latest 2026-11-17T08:24:06Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 24 times; this is ONE
coalesced notice that updates in place, not 24 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794903966 set-by=receipt:kriscendobot-garden-book:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1794903966 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3426s (since 2026-11-17T07:26:59Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- kriscendobot/test262: watcher ticking but cooldown for 3478s (since 2026-11-17T07:26:07Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3480s (since 2026-11-17T07:26:05Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3480s (since 2026-11-17T07:26:05Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3420s (since 2026-11-17T07:27:05Z)
- kriscendobot/list: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- kriscendobot/endo: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- kriscendobot/garden: watcher ticking but cooldown for 3437s (since 2026-11-17T07:26:48Z)
watcher ticking but cooldown for 3474s (since 2026-11-17T07:26:11Z); detail: rest latch set-by=receipt:kriscendobot-garden-book:PR source:primary-quota <- comment:source-timeout-fanout expiry=1794903966
- kriscendobot/minion.town: watcher ticking but cooldown for 3421s (since 2026-11-17T07:27:04Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3417s (since 2026-11-17T07:27:08Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3479s (since 2026-11-17T07:26:06Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3480s (since 2026-11-17T07:26:05Z)
