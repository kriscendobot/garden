from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-08T12:43:29Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 9
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-08T12:43:29Z
---
WATCHDOG notice — occurrence #9 (first seen 2026-11-07T22:15:24Z, latest 2026-11-08T12:43:29Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 9 times; this is ONE
coalesced notice that updates in place, not 9 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794144028 set-by=dependabot:kriscendobot-ocapn:source <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 1371s (since 2026-11-08T12:20:38Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1313s (since 2026-11-08T12:21:36Z)
- kriscendobot/test262: watcher ticking but cooldown for 1331s (since 2026-11-08T12:21:18Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1312s (since 2026-11-08T12:21:37Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1377s (since 2026-11-08T12:20:32Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1375s (since 2026-11-08T12:20:34Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1315s (since 2026-11-08T12:21:34Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1379s (since 2026-11-08T12:20:30Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1375s (since 2026-11-08T12:20:34Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1344s (since 2026-11-08T12:21:05Z)
- kriscendobot/list: watcher ticking but cooldown for 1367s (since 2026-11-08T12:20:42Z)
- kriscendobot/endo: watcher ticking but cooldown for 1368s (since 2026-11-08T12:20:41Z)
- kriscendobot/garden: watcher ticking but cooldown for 1347s (since 2026-11-08T12:21:02Z)
watcher ticking but cooldown for 1359s (since 2026-11-08T12:20:50Z); detail: rest latch set-by=dependabot:kriscendobot-ocapn:source <- pages:kriscendobot/garden:net expiry=1794144028
- kriscendobot/minion.town: watcher ticking but cooldown for 1364s (since 2026-11-08T12:20:45Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1303s (since 2026-11-08T12:21:46Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1300s (since 2026-11-08T12:21:49Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1319s (since 2026-11-08T12:21:30Z)
