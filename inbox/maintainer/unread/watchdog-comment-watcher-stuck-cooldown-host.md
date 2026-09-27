from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T18:40:35Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 23
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T18:40:35Z
---
WATCHDOG notice — occurrence #23 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T18:40:35Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 23 times; this is ONE
coalesced notice that updates in place, not 23 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 5 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790534465 cursor-get 
- kriscendobot/test262: watcher ticking but cooldown for 6165s (since 2026-09-27T16:57:50Z)
- kriscendobot/finbot: watcher ticking but cooldown for 9094s (since 2026-09-27T16:09:01Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 7301s (since 2026-09-27T16:38:54Z)
- kriscendobot/garden: watcher ticking but cooldown for 4332s (since 2026-09-27T17:28:23Z)
watcher ticking but cooldown for 5785s (since 2026-09-27T17:04:10Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 5782s (since 2026-09-27T17:04:13Z)
