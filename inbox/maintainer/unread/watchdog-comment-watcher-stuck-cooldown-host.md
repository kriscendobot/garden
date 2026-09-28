from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T07:06:13Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 50
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T07:06:13Z
---
WATCHDOG notice — occurrence #50 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T07:06:13Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 50 times; this is ONE
coalesced notice that updates in place, not 50 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 13 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790579417 set-by=receipt:kriscendobot-garden:journal prerequisite
- kriscendobot/cosgov: watcher ticking but cooldown for 6507s (since 2026-09-28T05:17:46Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1410s (since 2026-09-28T06:42:43Z)
- kriscendobot/finbot: watcher ticking but cooldown for 6558s (since 2026-09-28T05:16:55Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2133s (since 2026-09-28T06:30:40Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2908s (since 2026-09-28T06:17:45Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2093s (since 2026-09-28T06:31:20Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1362s (since 2026-09-28T06:43:31Z)
- kriscendobot/list: watcher ticking but cooldown for 2158s (since 2026-09-28T06:30:15Z)
- kriscendobot/endo: watcher ticking but cooldown for 6962s (since 2026-09-28T05:10:11Z)
- kriscendobot/garden: watcher ticking but cooldown for 6171s (since 2026-09-28T05:23:22Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1344s (since 2026-09-28T06:43:49Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 4683s (since 2026-09-28T05:48:10Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2100s (since 2026-09-28T06:31:13Z)
