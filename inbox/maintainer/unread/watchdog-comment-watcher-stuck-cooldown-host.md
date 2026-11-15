from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-15T19:58:49Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 16
first_seen: 2026-11-13T06:01:28Z
last_seen: 2026-11-15T19:58:49Z
---
WATCHDOG notice — occurrence #16 (first seen 2026-11-13T06:01:28Z, latest 2026-11-15T19:58:49Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 16 times; this is ONE
coalesced notice that updates in place, not 16 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794772845 set-by=receipt:kriscendobot-vattr97:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1794772844 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3484s (since 2026-11-15T19:00:45Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3483s (since 2026-11-15T19:00:46Z)
- kriscendobot/test262: watcher ticking but cooldown for 3483s (since 2026-11-15T19:00:46Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3473s (since 2026-11-15T19:00:56Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3439s (since 2026-11-15T19:01:30Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3483s (since 2026-11-15T19:00:46Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3450s (since 2026-11-15T19:01:19Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3470s (since 2026-11-15T19:00:59Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3481s (since 2026-11-15T19:00:48Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3443s (since 2026-11-15T19:01:26Z)
- kriscendobot/list: watcher ticking but cooldown for 3484s (since 2026-11-15T19:00:45Z)
- kriscendobot/endo: watcher ticking but cooldown for 3483s (since 2026-11-15T19:00:46Z)
- kriscendobot/garden: watcher ticking but cooldown for 3483s (since 2026-11-15T19:00:46Z)
watcher ticking but cooldown for 3484s (since 2026-11-15T19:00:45Z); detail: rest latch set-by=receipt:kriscendobot-vattr97:PR source:primary-quota <- comment:source-timeout-fanout expiry=1794772845
- kriscendobot/minion.town: watcher ticking but cooldown for 3483s (since 2026-11-15T19:00:46Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3409s (since 2026-11-15T19:02:00Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3453s (since 2026-11-15T19:01:16Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3485s (since 2026-11-15T19:00:44Z)
