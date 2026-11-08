from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-08T12:58:31Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 12
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-08T12:58:31Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-11-07T22:15:24Z, latest 2026-11-08T12:58:31Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794144028 set-by=dependabot:kriscendobot-ocapn:source <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 2273s (since 2026-11-08T12:20:38Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 2215s (since 2026-11-08T12:21:36Z)
- kriscendobot/test262: watcher ticking but cooldown for 2233s (since 2026-11-08T12:21:18Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2214s (since 2026-11-08T12:21:37Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2279s (since 2026-11-08T12:20:32Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2277s (since 2026-11-08T12:20:34Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2217s (since 2026-11-08T12:21:34Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2281s (since 2026-11-08T12:20:30Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2277s (since 2026-11-08T12:20:34Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2246s (since 2026-11-08T12:21:05Z)
- kriscendobot/list: watcher ticking but cooldown for 2269s (since 2026-11-08T12:20:42Z)
- kriscendobot/endo: watcher ticking but cooldown for 2270s (since 2026-11-08T12:20:41Z)
- kriscendobot/garden: watcher ticking but cooldown for 2249s (since 2026-11-08T12:21:02Z)
watcher ticking but cooldown for 2261s (since 2026-11-08T12:20:50Z); detail: rest latch set-by=dependabot:kriscendobot-ocapn:source <- pages:kriscendobot/garden:net expiry=1794144028
- kriscendobot/minion.town: watcher ticking but cooldown for 2266s (since 2026-11-08T12:20:45Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2205s (since 2026-11-08T12:21:46Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2202s (since 2026-11-08T12:21:49Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 2221s (since 2026-11-08T12:21:30Z)
