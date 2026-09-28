from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T02:45:57Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 41
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T02:45:57Z
---
WATCHDOG notice — occurrence #41 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T02:45:57Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 41 times; this is ONE
coalesced notice that updates in place, not 41 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 12 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790563836 set-by=receipt:kriscendobot-cosgov:journal prerequisite
journal-outage marker: 1790563652 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 3460s (since 2026-09-28T01:48:17Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3125s (since 2026-09-28T01:53:52Z)
- kriscendobot/moddable: watcher ticking but cooldown for 5748s (since 2026-09-28T01:10:09Z)
- kriscendobot/finbot: watcher ticking but cooldown for 5032s (since 2026-09-28T01:22:05Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 4358s (since 2026-09-28T01:33:19Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 7367s (since 2026-09-28T00:43:10Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 4676s (since 2026-09-28T01:28:01Z)
- kriscendobot/list: watcher ticking but cooldown for 6608s (since 2026-09-28T00:55:49Z)
- kriscendobot/garden: watcher ticking but cooldown for 5040s (since 2026-09-28T01:21:57Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 4354s (since 2026-09-28T01:33:23Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 4371s (since 2026-09-28T01:33:06Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 4360s (since 2026-09-28T01:33:17Z)
