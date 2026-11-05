from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T08:57:47Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 62
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T08:57:47Z
---
WATCHDOG notice — occurrence #62 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T08:57:47Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 62 times; this is ONE
coalesced notice that updates in place, not 62 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793869647 set-by=receipt:kriscendobot-ymax-e2e:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793869647 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3017s (since 2026-11-05T08:07:27Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3017s (since 2026-11-05T08:07:27Z)
- kriscendobot/test262: watcher ticking but cooldown for 3016s (since 2026-11-05T08:07:28Z)
- kriscendobot/moddable: watcher ticking but cooldown for 10877s (since 2026-11-05T05:56:27Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3016s (since 2026-11-05T08:07:28Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3016s (since 2026-11-05T08:07:28Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3017s (since 2026-11-05T08:07:27Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2975s (since 2026-11-05T08:08:09Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3017s (since 2026-11-05T08:07:27Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3016s (since 2026-11-05T08:07:28Z)
- kriscendobot/list: watcher ticking but cooldown for 2945s (since 2026-11-05T08:08:39Z)
- kriscendobot/endo: watcher ticking but cooldown for 3016s (since 2026-11-05T08:07:28Z)
- kriscendobot/garden: watcher ticking but cooldown for 3016s (since 2026-11-05T08:07:28Z)
watcher ticking but cooldown for 3017s (since 2026-11-05T08:07:27Z); detail: rest latch set-by=receipt:kriscendobot-ymax-e2e:PR source:primary-quota <- comment:source-timeout-fanout expiry=1793869647
- kriscendobot/minion.town: watcher ticking but cooldown for 3017s (since 2026-11-05T08:07:27Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3016s (since 2026-11-05T08:07:28Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2990s (since 2026-11-05T08:07:54Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 2977s (since 2026-11-05T08:08:07Z)
