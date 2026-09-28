from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T11:02:29Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 60
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T11:02:29Z
---
WATCHDOG notice — occurrence #60 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T11:02:29Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 60 times; this is ONE
coalesced notice that updates in place, not 60 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 11 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790593608 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
journal-outage marker: 1790593354 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 2792s (since 2026-09-28T10:15:43Z)
- kriscendobot/test262: watcher ticking but cooldown for 4325s (since 2026-09-28T09:50:10Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3918s (since 2026-09-28T09:56:57Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 4006s (since 2026-09-28T09:55:29Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3846s (since 2026-09-28T09:58:09Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 8030s (since 2026-09-28T08:48:25Z)
- kriscendobot/list: watcher ticking but cooldown for 3499s (since 2026-09-28T10:03:56Z)
- kriscendobot/endo: watcher ticking but cooldown for 4001s (since 2026-09-28T09:55:34Z)
- kriscendobot/garden: watcher ticking but cooldown for 3918s (since 2026-09-28T09:56:57Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3158s (since 2026-09-28T10:09:37Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3840s (since 2026-09-28T09:58:15Z)
