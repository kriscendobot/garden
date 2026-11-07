from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-07T22:35:26Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 5
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-07T22:35:26Z
---
WATCHDOG notice — occurrence #5 (first seen 2026-11-07T22:15:24Z, latest 2026-11-07T22:35:26Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 5 times; this is ONE
coalesced notice that updates in place, not 5 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794091919 set-by=comment:kriscendobot-oros-ckm-data-readiness:primary-quota <- gh-api:repos/kriscendobot/minion.town/pulls-review-metadata:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 2580s (since 2026-11-07T21:52:24Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 2540s (since 2026-11-07T21:53:04Z)
- kriscendobot/test262: watcher ticking but cooldown for 2515s (since 2026-11-07T21:53:29Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2555s (since 2026-11-07T21:52:49Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2591s (since 2026-11-07T21:52:13Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2600s (since 2026-11-07T21:52:04Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2559s (since 2026-11-07T21:52:45Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2566s (since 2026-11-07T21:52:38Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2576s (since 2026-11-07T21:52:28Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2566s (since 2026-11-07T21:52:38Z)
- kriscendobot/list: watcher ticking but cooldown for 2575s (since 2026-11-07T21:52:29Z)
- kriscendobot/endo: watcher ticking but cooldown for 2573s (since 2026-11-07T21:52:31Z)
- kriscendobot/garden: watcher ticking but cooldown for 2533s (since 2026-11-07T21:53:11Z)
watcher ticking but cooldown for 2589s (since 2026-11-07T21:52:15Z); detail: rest latch set-by=comment:kriscendobot-oros-ckm-data-readiness:primary-quota <- gh-api:repos/kriscendobot/minion.town/pulls-review-metadata:primary-quota expiry=1794091919
- kriscendobot/minion.town: watcher ticking but cooldown for 2605s (since 2026-11-07T21:51:59Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2605s (since 2026-11-07T21:51:59Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2566s (since 2026-11-07T21:52:38Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 2507s (since 2026-11-07T21:53:37Z)
