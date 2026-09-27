from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T19:30:23Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 25
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T19:30:23Z
---
WATCHDOG notice — occurrence #25 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T19:30:23Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 25 times; this is ONE
coalesced notice that updates in place, not 25 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790537452 cursor-get 
- kriscendobot/moddable: watcher ticking but cooldown for 1415s (since 2026-09-27T19:06:47Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2804s (since 2026-09-27T18:43:38Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2850s (since 2026-09-27T18:42:52Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 10288s (since 2026-09-27T16:38:54Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1372s (since 2026-09-27T19:07:30Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1416s (since 2026-09-27T19:06:46Z)
- kriscendobot/list: watcher ticking but cooldown for 2809s (since 2026-09-27T18:43:33Z)
- kriscendobot/garden: watcher ticking but cooldown for 1414s (since 2026-09-27T19:06:48Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1332s (since 2026-09-27T19:08:10Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 8769s (since 2026-09-27T17:04:13Z)
