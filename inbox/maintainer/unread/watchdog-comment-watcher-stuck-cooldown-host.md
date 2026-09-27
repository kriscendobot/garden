from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T23:50:42Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 35
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T23:50:42Z
---
WATCHDOG notice — occurrence #35 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T23:50:42Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 35 times; this is ONE
coalesced notice that updates in place, not 35 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 11 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790553060 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 5325s (since 2026-09-27T22:21:57Z)
- kriscendobot/test262: watcher ticking but cooldown for 2084s (since 2026-09-27T23:15:58Z)
- kriscendobot/moddable: watcher ticking but cooldown for 5344s (since 2026-09-27T22:21:38Z)
- kriscendobot/finbot: watcher ticking but cooldown for 6026s (since 2026-09-27T22:10:16Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2393s (since 2026-09-27T23:10:49Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2388s (since 2026-09-27T23:10:54Z)
- kriscendobot/list: watcher ticking but cooldown for 3792s (since 2026-09-27T22:47:30Z)
- kriscendobot/endo: watcher ticking but cooldown for 5672s (since 2026-09-27T22:16:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 4955s (since 2026-09-27T22:28:07Z)
watcher ticking but cooldown for 1246s (since 2026-09-27T23:29:56Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2350s (since 2026-09-27T23:11:32Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 5322s (since 2026-09-27T22:22:00Z)
