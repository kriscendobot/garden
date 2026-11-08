from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-08T13:13:32Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 15
first_seen: 2026-11-07T22:15:24Z
last_seen: 2026-11-08T13:13:32Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-11-07T22:15:24Z, latest 2026-11-08T13:13:32Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794144028 set-by=dependabot:kriscendobot-ocapn:source <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 3173s (since 2026-11-08T12:20:38Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3115s (since 2026-11-08T12:21:36Z)
- kriscendobot/test262: watcher ticking but cooldown for 3133s (since 2026-11-08T12:21:18Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3114s (since 2026-11-08T12:21:37Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3179s (since 2026-11-08T12:20:32Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3177s (since 2026-11-08T12:20:34Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3117s (since 2026-11-08T12:21:34Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3181s (since 2026-11-08T12:20:30Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3177s (since 2026-11-08T12:20:34Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3146s (since 2026-11-08T12:21:05Z)
- kriscendobot/list: watcher ticking but cooldown for 3169s (since 2026-11-08T12:20:42Z)
- kriscendobot/endo: watcher ticking but cooldown for 3170s (since 2026-11-08T12:20:41Z)
- kriscendobot/garden: watcher ticking but cooldown for 3149s (since 2026-11-08T12:21:02Z)
watcher ticking but cooldown for 3161s (since 2026-11-08T12:20:50Z); detail: rest latch set-by=dependabot:kriscendobot-ocapn:source <- pages:kriscendobot/garden:net expiry=1794144028
- kriscendobot/minion.town: watcher ticking but cooldown for 3166s (since 2026-11-08T12:20:45Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3105s (since 2026-11-08T12:21:46Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3102s (since 2026-11-08T12:21:49Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3121s (since 2026-11-08T12:21:30Z)
