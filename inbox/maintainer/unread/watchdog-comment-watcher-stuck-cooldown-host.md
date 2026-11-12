from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-12T20:50:24Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 31
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-12T20:50:24Z
---
WATCHDOG notice — occurrence #31 (first seen 2026-11-07T22:15:24Z, latest 2026-11-12T20:50:24Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 31 times; this is ONE
coalesced notice that updates in place, not 31 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794517127 set-by=dependabot:kriscendobot-endo-but-for-bots:source <- pages:kriscendobot/garden:net
gh-api GraphQL-only marker: expiry=1794517127 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3075s (since 2026-11-12T19:59:09Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3087s (since 2026-11-12T19:58:57Z)
- kriscendobot/test262: watcher ticking but cooldown for 3097s (since 2026-11-12T19:58:47Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3097s (since 2026-11-12T19:58:47Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3097s (since 2026-11-12T19:58:47Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3097s (since 2026-11-12T19:58:47Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3096s (since 2026-11-12T19:58:48Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3033s (since 2026-11-12T19:59:51Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3097s (since 2026-11-12T19:58:47Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3073s (since 2026-11-12T19:59:11Z)
- kriscendobot/list: watcher ticking but cooldown for 3066s (since 2026-11-12T19:59:18Z)
- kriscendobot/endo: watcher ticking but cooldown for 3097s (since 2026-11-12T19:58:47Z)
- kriscendobot/garden: watcher ticking but cooldown for 3039s (since 2026-11-12T19:59:45Z)
watcher ticking but cooldown for 3094s (since 2026-11-12T19:58:50Z); detail: rest latch set-by=dependabot:kriscendobot-endo-but-for-bots:source <- pages:kriscendobot/garden:net expiry=1794517127
- kriscendobot/minion.town: watcher ticking but cooldown for 3097s (since 2026-11-12T19:58:47Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3046s (since 2026-11-12T19:59:38Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3078s (since 2026-11-12T19:59:06Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3082s (since 2026-11-12T19:59:02Z)
