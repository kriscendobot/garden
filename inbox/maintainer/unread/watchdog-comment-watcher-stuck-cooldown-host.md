from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T10:17:51Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 70
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T10:17:51Z
---
WATCHDOG notice — occurrence #70 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T10:17:51Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 70 times; this is ONE
coalesced notice that updates in place, not 70 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793874014 set-by=receipt:kriscendobot-endo:PR source:primary-quota <- receipt:kriscendobot-minion.town:receipt generate
gh-api GraphQL-only marker: expiry=1793874014 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 1381s (since 2026-11-05T09:54:47Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1394s (since 2026-11-05T09:54:34Z)
- kriscendobot/test262: watcher ticking but cooldown for 1460s (since 2026-11-05T09:53:28Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1393s (since 2026-11-05T09:54:35Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1375s (since 2026-11-05T09:54:53Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3453s (since 2026-11-05T09:20:15Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1390s (since 2026-11-05T09:54:38Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1441s (since 2026-11-05T09:53:47Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1387s (since 2026-11-05T09:54:41Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1381s (since 2026-11-05T09:54:47Z)
- kriscendobot/list: watcher ticking but cooldown for 1382s (since 2026-11-05T09:54:46Z)
- kriscendobot/endo: watcher ticking but cooldown for 1380s (since 2026-11-05T09:54:48Z)
- kriscendobot/garden: watcher ticking but cooldown for 1451s (since 2026-11-05T09:53:37Z)
watcher ticking but cooldown for 1396s (since 2026-11-05T09:54:32Z); detail: rest latch set-by=receipt:kriscendobot-endo:PR source:primary-quota <- receipt:kriscendobot-minion.town:receipt generate expiry=1793874014
- kriscendobot/minion.town: watcher ticking but cooldown for 1434s (since 2026-11-05T09:53:54Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1356s (since 2026-11-05T09:55:12Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1366s (since 2026-11-05T09:55:02Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3455s (since 2026-11-05T09:20:13Z)
