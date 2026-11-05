from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T07:47:22Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 48
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T07:47:22Z
---
WATCHDOG notice — occurrence #48 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T07:47:22Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 48 times; this is ONE
coalesced notice that updates in place, not 48 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793865712 set-by=receipt:kriscendobot-endo:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793865712 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 6650s (since 2026-11-05T05:56:28Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 2656s (since 2026-11-05T07:03:02Z)
- kriscendobot/test262: watcher ticking but cooldown for 2727s (since 2026-11-05T07:01:51Z)
- kriscendobot/moddable: watcher ticking but cooldown for 6651s (since 2026-11-05T05:56:27Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2725s (since 2026-11-05T07:01:53Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2726s (since 2026-11-05T07:01:52Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2724s (since 2026-11-05T07:01:54Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2726s (since 2026-11-05T07:01:52Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2727s (since 2026-11-05T07:01:51Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2725s (since 2026-11-05T07:01:53Z)
- kriscendobot/list: watcher ticking but cooldown for 2684s (since 2026-11-05T07:02:34Z)
- kriscendobot/endo: watcher ticking but cooldown for 2719s (since 2026-11-05T07:01:59Z)
- kriscendobot/garden: watcher ticking but cooldown for 6590s (since 2026-11-05T05:57:28Z)
watcher ticking but cooldown for 2725s (since 2026-11-05T07:01:53Z); detail: rest latch set-by=receipt:kriscendobot-endo:PR source:primary-quota <- comment:source-timeout-fanout expiry=1793865712
- kriscendobot/minion.town: watcher ticking but cooldown for 2725s (since 2026-11-05T07:01:53Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2695s (since 2026-11-05T07:02:23Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 10575s (since 2026-11-05T04:51:03Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 2681s (since 2026-11-05T07:02:37Z)
