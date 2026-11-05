from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T06:27:07Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 33
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T06:27:07Z
---
WATCHDOG notice — occurrence #33 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T06:27:07Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 33 times; this is ONE
coalesced notice that updates in place, not 33 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793861786 set-by=receipt:kriscendobot-list:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793861786 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 1836s (since 2026-11-05T05:56:28Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1752s (since 2026-11-05T05:57:52Z)
- kriscendobot/test262: watcher ticking but cooldown for 1832s (since 2026-11-05T05:56:32Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1837s (since 2026-11-05T05:56:27Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1837s (since 2026-11-05T05:56:27Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1752s (since 2026-11-05T05:57:52Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 5760s (since 2026-11-05T04:51:04Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 9743s (since 2026-11-05T03:44:41Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1782s (since 2026-11-05T05:57:22Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1838s (since 2026-11-05T05:56:26Z)
- kriscendobot/list: watcher ticking but cooldown for 1837s (since 2026-11-05T05:56:27Z)
- kriscendobot/endo: watcher ticking but cooldown for 1838s (since 2026-11-05T05:56:26Z)
- kriscendobot/garden: watcher ticking but cooldown for 1776s (since 2026-11-05T05:57:28Z)
watcher ticking but cooldown for 1838s (since 2026-11-05T05:56:26Z); detail: rest latch set-by=receipt:kriscendobot-list:PR source:primary-quota <- comment:source-timeout-fanout expiry=1793861786
- kriscendobot/minion.town: watcher ticking but cooldown for 1837s (since 2026-11-05T05:56:27Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1837s (since 2026-11-05T05:56:27Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 5761s (since 2026-11-05T04:51:03Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1837s (since 2026-11-05T05:56:27Z)
