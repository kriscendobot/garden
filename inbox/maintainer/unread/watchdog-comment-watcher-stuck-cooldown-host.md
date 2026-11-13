from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-13T06:16:31Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 4
first_seen: 2026-11-13T06:01:28Z
last_seen: 2026-11-13T06:16:31Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-11-13T06:01:28Z, latest 2026-11-13T06:16:31Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794551981 set-by=dependabot:kriscendobot-garden:source <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 2136s (since 2026-11-13T05:40:54Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 2148s (since 2026-11-13T05:40:42Z)
- kriscendobot/test262: watcher ticking but cooldown for 2208s (since 2026-11-13T05:39:42Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2185s (since 2026-11-13T05:40:05Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2197s (since 2026-11-13T05:39:53Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2209s (since 2026-11-13T05:39:41Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2125s (since 2026-11-13T05:41:05Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2209s (since 2026-11-13T05:39:41Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2209s (since 2026-11-13T05:39:41Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2172s (since 2026-11-13T05:40:18Z)
- kriscendobot/list: watcher ticking but cooldown for 2189s (since 2026-11-13T05:40:01Z)
- kriscendobot/endo: watcher ticking but cooldown for 2180s (since 2026-11-13T05:40:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 2178s (since 2026-11-13T05:40:12Z)
watcher ticking but cooldown for 2206s (since 2026-11-13T05:39:44Z); detail: rest latch set-by=dependabot:kriscendobot-garden:source <- pages:kriscendobot/garden:net expiry=1794551981
- kriscendobot/minion.town: watcher ticking but cooldown for 2185s (since 2026-11-13T05:40:05Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2129s (since 2026-11-13T05:41:01Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2150s (since 2026-11-13T05:40:40Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 2209s (since 2026-11-13T05:39:41Z)
