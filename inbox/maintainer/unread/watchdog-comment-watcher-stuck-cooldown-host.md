from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T17:52:10Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 74
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T17:52:10Z
---
WATCHDOG notice — occurrence #74 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T17:52:10Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 74 times; this is ONE
coalesced notice that updates in place, not 74 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790618202 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
- kriscendobot/cosgov: watcher ticking but cooldown for 4235s (since 2026-09-28T16:41:35Z)
- kriscendobot/moddable: watcher ticking but cooldown for 4346s (since 2026-09-28T16:39:44Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1383s (since 2026-09-28T17:29:07Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1390s (since 2026-09-28T17:29:00Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2778s (since 2026-09-28T17:05:52Z)
- kriscendobot/endo: watcher ticking but cooldown for 1310s (since 2026-09-28T17:30:20Z)
- kriscendobot/garden: watcher ticking but cooldown for 2457s (since 2026-09-28T17:11:13Z)
watcher ticking but cooldown for 4290s (since 2026-09-28T16:40:40Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2461s (since 2026-09-28T17:11:09Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 4346s (since 2026-09-28T16:39:44Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1385s (since 2026-09-28T17:29:05Z)
