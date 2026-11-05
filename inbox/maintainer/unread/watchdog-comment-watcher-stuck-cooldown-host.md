from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T07:42:19Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 47
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T07:42:19Z
---
WATCHDOG notice — occurrence #47 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T07:42:19Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 47 times; this is ONE
coalesced notice that updates in place, not 47 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793865712 set-by=receipt:kriscendobot-endo:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793865712 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 6350s (since 2026-11-05T05:56:28Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 2356s (since 2026-11-05T07:03:02Z)
- kriscendobot/test262: watcher ticking but cooldown for 2427s (since 2026-11-05T07:01:51Z)
- kriscendobot/moddable: watcher ticking but cooldown for 6351s (since 2026-11-05T05:56:27Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2425s (since 2026-11-05T07:01:53Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2426s (since 2026-11-05T07:01:52Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2424s (since 2026-11-05T07:01:54Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2426s (since 2026-11-05T07:01:52Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2427s (since 2026-11-05T07:01:51Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2425s (since 2026-11-05T07:01:53Z)
- kriscendobot/list: watcher ticking but cooldown for 2384s (since 2026-11-05T07:02:34Z)
- kriscendobot/endo: watcher ticking but cooldown for 2419s (since 2026-11-05T07:01:59Z)
- kriscendobot/garden: watcher ticking but cooldown for 6290s (since 2026-11-05T05:57:28Z)
watcher ticking but cooldown for 2425s (since 2026-11-05T07:01:53Z); detail: rest latch set-by=receipt:kriscendobot-endo:PR source:primary-quota <- comment:source-timeout-fanout expiry=1793865712
- kriscendobot/minion.town: watcher ticking but cooldown for 2425s (since 2026-11-05T07:01:53Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2395s (since 2026-11-05T07:02:23Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 10275s (since 2026-11-05T04:51:03Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 2381s (since 2026-11-05T07:02:37Z)
