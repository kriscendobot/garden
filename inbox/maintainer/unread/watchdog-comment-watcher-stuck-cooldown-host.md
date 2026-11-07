from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-07T22:20:24Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 2
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-07T22:20:24Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-11-07T22:15:24Z, latest 2026-11-07T22:20:24Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794091919 set-by=comment:kriscendobot-oros-ckm-data-readiness:primary-quota <- gh-api:repos/kriscendobot/minion.town/pulls-review-metadata:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 1679s (since 2026-11-07T21:52:24Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1639s (since 2026-11-07T21:53:04Z)
- kriscendobot/test262: watcher ticking but cooldown for 1614s (since 2026-11-07T21:53:29Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1654s (since 2026-11-07T21:52:49Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1690s (since 2026-11-07T21:52:13Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1699s (since 2026-11-07T21:52:04Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1658s (since 2026-11-07T21:52:45Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1665s (since 2026-11-07T21:52:38Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1675s (since 2026-11-07T21:52:28Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1665s (since 2026-11-07T21:52:38Z)
- kriscendobot/list: watcher ticking but cooldown for 1674s (since 2026-11-07T21:52:29Z)
- kriscendobot/endo: watcher ticking but cooldown for 1672s (since 2026-11-07T21:52:31Z)
- kriscendobot/garden: watcher ticking but cooldown for 1632s (since 2026-11-07T21:53:11Z)
watcher ticking but cooldown for 1688s (since 2026-11-07T21:52:15Z); detail: rest latch set-by=comment:kriscendobot-oros-ckm-data-readiness:primary-quota <- gh-api:repos/kriscendobot/minion.town/pulls-review-metadata:primary-quota expiry=1794091919
- kriscendobot/minion.town: watcher ticking but cooldown for 1704s (since 2026-11-07T21:51:59Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1704s (since 2026-11-07T21:51:59Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1665s (since 2026-11-07T21:52:38Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1606s (since 2026-11-07T21:53:37Z)
