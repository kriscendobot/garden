from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T11:57:20Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 62
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T11:57:20Z
---
WATCHDOG notice — occurrence #62 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T11:57:20Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 62 times; this is ONE
coalesced notice that updates in place, not 62 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790596889 set-by=receipt:kriscendobot-ymax-e2e:journal prerequisite
journal-outage marker: 1790596703 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 6091s (since 2026-09-28T10:15:43Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1403s (since 2026-09-28T11:33:51Z)
- kriscendobot/test262: watcher ticking but cooldown for 7624s (since 2026-09-28T09:50:10Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2411s (since 2026-09-28T11:17:03Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2036s (since 2026-09-28T11:23:18Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2086s (since 2026-09-28T11:22:28Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2050s (since 2026-09-28T11:23:04Z)
- kriscendobot/list: watcher ticking but cooldown for 6798s (since 2026-09-28T10:03:56Z)
- kriscendobot/garden: watcher ticking but cooldown for 2042s (since 2026-09-28T11:23:12Z)
watcher ticking but cooldown for 2473s (since 2026-09-28T11:16:01Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 7139s (since 2026-09-28T09:58:15Z)
