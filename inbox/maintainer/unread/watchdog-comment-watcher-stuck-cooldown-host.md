from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T05:46:31Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 25
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T05:46:31Z
---
WATCHDOG notice — occurrence #25 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T05:46:31Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 25 times; this is ONE
coalesced notice that updates in place, not 25 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793857863 set-by=receipt:kriscendobot-ymax-stdio-mcp:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793857863 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3325s (since 2026-11-05T04:51:03Z)
- kriscendobot/test262: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3325s (since 2026-11-05T04:51:03Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3303s (since 2026-11-05T04:51:25Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 7307s (since 2026-11-05T03:44:41Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3281s (since 2026-11-05T04:51:47Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
- kriscendobot/list: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
- kriscendobot/endo: watcher ticking but cooldown for 3325s (since 2026-11-05T04:51:03Z)
- kriscendobot/garden: watcher ticking but cooldown for 3282s (since 2026-11-05T04:51:46Z)
watcher ticking but cooldown for 3322s (since 2026-11-05T04:51:06Z); detail: rest latch set-by=receipt:kriscendobot-ymax-stdio-mcp:PR source:primary-quota <- comment:source-timeout-fanout expiry=1793857863
- kriscendobot/minion.town: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3325s (since 2026-11-05T04:51:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3325s (since 2026-11-05T04:51:03Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3324s (since 2026-11-05T04:51:04Z)
