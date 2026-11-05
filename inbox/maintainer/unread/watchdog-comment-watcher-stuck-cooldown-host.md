from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T09:47:49Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 65
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T09:47:49Z
---
WATCHDOG notice — occurrence #65 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T09:47:49Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 65 times; this is ONE
coalesced notice that updates in place, not 65 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793874014 set-by=receipt:kriscendobot-endo:PR source:primary-quota <- receipt:kriscendobot-minion.town:receipt generate
gh-api GraphQL-only marker: expiry=1793874014 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 1640s (since 2026-11-05T09:20:26Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/test262: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1653s (since 2026-11-05T09:20:13Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/list: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/endo: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/garden: watcher ticking but cooldown for 1650s (since 2026-11-05T09:20:16Z)
watcher ticking but cooldown for 1652s (since 2026-11-05T09:20:14Z); detail: rest latch set-by=receipt:kriscendobot-endo:PR source:primary-quota <- receipt:kriscendobot-minion.town:receipt generate expiry=1793874014
- kriscendobot/minion.town: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1651s (since 2026-11-05T09:20:15Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1649s (since 2026-11-05T09:20:17Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1653s (since 2026-11-05T09:20:13Z)
