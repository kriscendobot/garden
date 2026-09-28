from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T09:12:28Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 55
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T09:12:28Z
---
WATCHDOG notice — occurrence #55 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T09:12:28Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 55 times; this is ONE
coalesced notice that updates in place, not 55 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 9 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790586939 set-by=receipt:kriscendobot-test262:journal prerequisite
journal-outage marker: 1790586854 cursor-get 
- kriscendobot/test262: watcher ticking but cooldown for 3688s (since 2026-09-28T08:11:00Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1457s (since 2026-09-28T08:48:11Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1447s (since 2026-09-28T08:48:21Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1797s (since 2026-09-28T08:42:31Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1443s (since 2026-09-28T08:48:25Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1454s (since 2026-09-28T08:48:14Z)
- kriscendobot/garden: watcher ticking but cooldown for 1382s (since 2026-09-28T08:49:26Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1450s (since 2026-09-28T08:48:18Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1436s (since 2026-09-28T08:48:32Z)
