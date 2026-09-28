from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T16:32:00Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 72
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T16:32:00Z
---
WATCHDOG notice — occurrence #72 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T16:32:00Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 72 times; this is ONE
coalesced notice that updates in place, not 72 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 8 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790613388 set-by=receipt:kriscendobot-endo:journal prerequisite
- kriscendobot/cosgov: watcher ticking but cooldown for 1454s (since 2026-09-28T16:07:45Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1468s (since 2026-09-28T16:07:31Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1457s (since 2026-09-28T16:07:42Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1457s (since 2026-09-28T16:07:42Z)
- kriscendobot/list: watcher ticking but cooldown for 1410s (since 2026-09-28T16:08:29Z)
- kriscendobot/endo: watcher ticking but cooldown for 1466s (since 2026-09-28T16:07:33Z)
- kriscendobot/garden: watcher ticking but cooldown for 1782s (since 2026-09-28T16:02:17Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1458s (since 2026-09-28T16:07:41Z)
