from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-13T06:11:29Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 3
first_seen: 2026-11-13T06:01:28Z
last_seen: 2026-11-13T06:11:29Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-11-13T06:01:28Z, latest 2026-11-13T06:11:29Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794551981 set-by=dependabot:kriscendobot-garden:source <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 1834s (since 2026-11-13T05:40:54Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1846s (since 2026-11-13T05:40:42Z)
- kriscendobot/test262: watcher ticking but cooldown for 1906s (since 2026-11-13T05:39:42Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1883s (since 2026-11-13T05:40:05Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1895s (since 2026-11-13T05:39:53Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1907s (since 2026-11-13T05:39:41Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1823s (since 2026-11-13T05:41:05Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1907s (since 2026-11-13T05:39:41Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1907s (since 2026-11-13T05:39:41Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1870s (since 2026-11-13T05:40:18Z)
- kriscendobot/list: watcher ticking but cooldown for 1887s (since 2026-11-13T05:40:01Z)
- kriscendobot/endo: watcher ticking but cooldown for 1878s (since 2026-11-13T05:40:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 1876s (since 2026-11-13T05:40:12Z)
watcher ticking but cooldown for 1904s (since 2026-11-13T05:39:44Z); detail: rest latch set-by=dependabot:kriscendobot-garden:source <- pages:kriscendobot/garden:net expiry=1794551981
- kriscendobot/minion.town: watcher ticking but cooldown for 1883s (since 2026-11-13T05:40:05Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1827s (since 2026-11-13T05:41:01Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1848s (since 2026-11-13T05:40:40Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1907s (since 2026-11-13T05:39:41Z)
