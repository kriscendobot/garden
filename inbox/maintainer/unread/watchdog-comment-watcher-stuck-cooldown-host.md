from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T01:25:44Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 38
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T01:25:44Z
---
WATCHDOG notice — occurrence #38 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T01:25:44Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 38 times; this is ONE
coalesced notice that updates in place, not 38 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790559000 set-by=receipt:kriscendobot-minion.town:journal prerequisite
- kriscendobot/cosgov: watcher ticking but cooldown for 2114s (since 2026-09-28T00:50:30Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1372s (since 2026-09-28T01:02:52Z)
- kriscendobot/test262: watcher ticking but cooldown for 1794s (since 2026-09-28T00:55:50Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2549s (since 2026-09-28T00:43:15Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2554s (since 2026-09-28T00:43:10Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1383s (since 2026-09-28T01:02:41Z)
- kriscendobot/list: watcher ticking but cooldown for 1795s (since 2026-09-28T00:55:49Z)
- kriscendobot/garden: watcher ticking but cooldown for 1789s (since 2026-09-28T00:55:55Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2549s (since 2026-09-28T00:43:15Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1371s (since 2026-09-28T01:02:53Z)
