from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-10T03:24:43Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 24
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-10T03:24:43Z
---
WATCHDOG notice — occurrence #24 (first seen 2026-11-07T22:15:24Z, latest 2026-11-10T03:24:43Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 24 times; this is ONE
coalesced notice that updates in place, not 24 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794281157 set-by=receipt:kriscendobot-moddable:PR source:primary-quota <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/test262: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3513s (since 2026-11-10T02:26:10Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3518s (since 2026-11-10T02:26:05Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3516s (since 2026-11-10T02:26:07Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/list: watcher ticking but cooldown for 3506s (since 2026-11-10T02:26:17Z)
- kriscendobot/endo: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/garden: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
watcher ticking but cooldown for 3482s (since 2026-11-10T02:26:41Z); detail: rest latch set-by=receipt:kriscendobot-moddable:PR source:primary-quota <- pages:kriscendobot/garden:net expiry=1794281157
- kriscendobot/minion.town: watcher ticking but cooldown for 3525s (since 2026-11-10T02:25:58Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3527s (since 2026-11-10T02:25:56Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3526s (since 2026-11-10T02:25:57Z)
