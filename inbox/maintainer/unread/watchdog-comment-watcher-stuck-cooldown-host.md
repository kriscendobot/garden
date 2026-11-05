from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T04:11:28Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 6
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T04:11:28Z
---
WATCHDOG notice — occurrence #6 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T04:11:28Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 6 times; this is ONE
coalesced notice that updates in place, not 6 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793853880 set-by=dependabot:kriscendobot-ymax-stdio-mcp:source <- comment:source-timeout-fanout
- kriscendobot/cosgov: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
- kriscendobot/test262: watcher ticking but cooldown for 1600s (since 2026-11-05T03:44:40Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1599s (since 2026-11-05T03:44:41Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1600s (since 2026-11-05T03:44:40Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1599s (since 2026-11-05T03:44:41Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1600s (since 2026-11-05T03:44:40Z)
- kriscendobot/list: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
- kriscendobot/endo: watcher ticking but cooldown for 1600s (since 2026-11-05T03:44:40Z)
- kriscendobot/garden: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
watcher ticking but cooldown for 1600s (since 2026-11-05T03:44:40Z); detail: rest latch set-by=dependabot:kriscendobot-ymax-stdio-mcp:source <- comment:source-timeout-fanout expiry=1793853880
- kriscendobot/minion.town: watcher ticking but cooldown for 1600s (since 2026-11-05T03:44:40Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1598s (since 2026-11-05T03:44:42Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1601s (since 2026-11-05T03:44:39Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1600s (since 2026-11-05T03:44:40Z)
