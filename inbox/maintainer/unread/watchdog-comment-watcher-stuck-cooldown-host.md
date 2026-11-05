from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T03:21:19Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 3
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T03:21:19Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T03:21:19Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 16 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793849419 set-by=receipt:kriscendobot-garden:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793849419 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/test262: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3039s (since 2026-11-05T02:30:39Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3039s (since 2026-11-05T02:30:39Z)
- kriscendobot/list: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/endo: watcher ticking but cooldown for 2987s (since 2026-11-05T02:31:31Z)
- kriscendobot/garden: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z); detail: rest latch set-by=receipt:kriscendobot-garden:PR source:primary-quota <- comment:source-timeout-fanout expiry=1793849419
- kriscendobot/minion.town: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3039s (since 2026-11-05T02:30:39Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3059s (since 2026-11-05T02:30:19Z)
