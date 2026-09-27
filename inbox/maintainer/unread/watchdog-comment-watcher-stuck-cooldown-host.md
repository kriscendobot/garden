from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T21:35:29Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 30
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T21:35:29Z
---
WATCHDOG notice — occurrence #30 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T21:35:29Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 30 times; this is ONE
coalesced notice that updates in place, not 30 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790544961 cursor-set 
- kriscendobot/test262: watcher ticking but cooldown for 1713s (since 2026-09-27T21:06:56Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 6944s (since 2026-09-27T19:39:45Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1720s (since 2026-09-27T21:06:49Z)
