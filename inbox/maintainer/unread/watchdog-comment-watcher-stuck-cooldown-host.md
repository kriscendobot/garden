from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T06:17:12Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 31
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T06:17:12Z
---
WATCHDOG notice — occurrence #31 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T06:17:12Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 31 times; this is ONE
coalesced notice that updates in place, not 31 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 14 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793861786 set-by=receipt:kriscendobot-list:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793861786 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 1236s (since 2026-11-05T05:56:28Z)
- kriscendobot/test262: watcher ticking but cooldown for 1232s (since 2026-11-05T05:56:32Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1237s (since 2026-11-05T05:56:27Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1237s (since 2026-11-05T05:56:27Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 5160s (since 2026-11-05T04:51:04Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 9143s (since 2026-11-05T03:44:41Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1238s (since 2026-11-05T05:56:26Z)
- kriscendobot/list: watcher ticking but cooldown for 1237s (since 2026-11-05T05:56:27Z)
- kriscendobot/endo: watcher ticking but cooldown for 1238s (since 2026-11-05T05:56:26Z)
- kriscendobot/garden: watcher ticking but cooldown for 1238s (since 2026-11-05T05:56:26Z); detail: rest latch set-by=receipt:kriscendobot-list:PR source:primary-quota <- comment:source-timeout-fanout expiry=1793861786
- kriscendobot/minion.town: watcher ticking but cooldown for 1237s (since 2026-11-05T05:56:27Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1237s (since 2026-11-05T05:56:27Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 5161s (since 2026-11-05T04:51:03Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1237s (since 2026-11-05T05:56:27Z)
