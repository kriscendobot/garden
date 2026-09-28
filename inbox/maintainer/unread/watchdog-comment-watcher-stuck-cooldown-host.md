from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T17:27:24Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 73
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T17:27:24Z
---
WATCHDOG notice — occurrence #73 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T17:27:24Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 73 times; this is ONE
coalesced notice that updates in place, not 73 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 8 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790616531 approval-reconciler-verify 
- kriscendobot/cosgov: watcher ticking but cooldown for 2749s (since 2026-09-28T16:41:35Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1992s (since 2026-09-28T16:54:12Z)
- kriscendobot/test262: watcher ticking but cooldown for 2342s (since 2026-09-28T16:48:22Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2860s (since 2026-09-28T16:39:44Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2814s (since 2026-09-28T16:40:30Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1292s (since 2026-09-28T17:05:52Z)
- kriscendobot/garden: watcher ticking but cooldown for 2804s (since 2026-09-28T16:40:40Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2860s (since 2026-09-28T16:39:44Z)
