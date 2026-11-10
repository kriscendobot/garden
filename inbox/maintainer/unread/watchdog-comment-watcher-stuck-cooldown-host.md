from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-10T02:49:41Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 17
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-10T02:49:41Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-11-07T22:15:24Z, latest 2026-11-10T02:49:41Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794281157 set-by=receipt:kriscendobot-moddable:PR source:primary-quota <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/test262: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1411s (since 2026-11-10T02:26:10Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1416s (since 2026-11-10T02:26:05Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1414s (since 2026-11-10T02:26:07Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/list: watcher ticking but cooldown for 1404s (since 2026-11-10T02:26:17Z)
- kriscendobot/endo: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/garden: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
watcher ticking but cooldown for 1380s (since 2026-11-10T02:26:41Z); detail: rest latch set-by=receipt:kriscendobot-moddable:PR source:primary-quota <- pages:kriscendobot/garden:net expiry=1794281157
- kriscendobot/minion.town: watcher ticking but cooldown for 1423s (since 2026-11-10T02:25:58Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1425s (since 2026-11-10T02:25:56Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1424s (since 2026-11-10T02:25:57Z)
