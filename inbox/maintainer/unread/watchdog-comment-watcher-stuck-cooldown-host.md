from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-13T06:36:31Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 8
first_seen: 2026-11-13T06:01:28Z
last_seen: 2026-11-13T06:36:31Z
---
WATCHDOG notice — occurrence #8 (first seen 2026-11-13T06:01:28Z, latest 2026-11-13T06:36:31Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 8 times; this is ONE
coalesced notice that updates in place, not 8 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794551981 set-by=dependabot:kriscendobot-garden:source <- pages:kriscendobot/garden:net
- kriscendobot/cosgov: watcher ticking but cooldown for 3335s (since 2026-11-13T05:40:54Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3347s (since 2026-11-13T05:40:42Z)
- kriscendobot/test262: watcher ticking but cooldown for 3407s (since 2026-11-13T05:39:42Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3384s (since 2026-11-13T05:40:05Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3396s (since 2026-11-13T05:39:53Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3408s (since 2026-11-13T05:39:41Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3324s (since 2026-11-13T05:41:05Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3408s (since 2026-11-13T05:39:41Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3408s (since 2026-11-13T05:39:41Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3371s (since 2026-11-13T05:40:18Z)
- kriscendobot/list: watcher ticking but cooldown for 3388s (since 2026-11-13T05:40:01Z)
- kriscendobot/endo: watcher ticking but cooldown for 3379s (since 2026-11-13T05:40:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 3377s (since 2026-11-13T05:40:12Z)
watcher ticking but cooldown for 3405s (since 2026-11-13T05:39:44Z); detail: rest latch set-by=dependabot:kriscendobot-garden:source <- pages:kriscendobot/garden:net expiry=1794551981
- kriscendobot/minion.town: watcher ticking but cooldown for 3384s (since 2026-11-13T05:40:05Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3328s (since 2026-11-13T05:41:01Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3349s (since 2026-11-13T05:40:40Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3408s (since 2026-11-13T05:39:41Z)
