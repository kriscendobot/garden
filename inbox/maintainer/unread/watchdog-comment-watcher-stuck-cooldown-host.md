from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T02:20:38Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 40
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T02:20:38Z
---
WATCHDOG notice — occurrence #40 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T02:20:38Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 40 times; this is ONE
coalesced notice that updates in place, not 40 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 15 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790562337 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
journal-outage marker: 1790562084 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 1941s (since 2026-09-28T01:48:17Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1606s (since 2026-09-28T01:53:52Z)
- kriscendobot/moddable: watcher ticking but cooldown for 4229s (since 2026-09-28T01:10:09Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3513s (since 2026-09-28T01:22:05Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 5843s (since 2026-09-28T00:43:15Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2839s (since 2026-09-28T01:33:19Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 5848s (since 2026-09-28T00:43:10Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3157s (since 2026-09-28T01:28:01Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1972s (since 2026-09-28T01:47:46Z)
- kriscendobot/list: watcher ticking but cooldown for 5089s (since 2026-09-28T00:55:49Z)
- kriscendobot/endo: watcher ticking but cooldown for 2834s (since 2026-09-28T01:33:24Z)
- kriscendobot/garden: watcher ticking but cooldown for 3521s (since 2026-09-28T01:21:57Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2835s (since 2026-09-28T01:33:23Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2852s (since 2026-09-28T01:33:06Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2841s (since 2026-09-28T01:33:17Z)
