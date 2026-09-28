from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T08:46:41Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 54
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T08:46:41Z
---
WATCHDOG notice — occurrence #54 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T08:46:41Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 54 times; this is ONE
coalesced notice that updates in place, not 54 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 2 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790585215 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 2132s (since 2026-09-28T08:11:09Z)
- kriscendobot/test262: watcher ticking but cooldown for 2141s (since 2026-09-28T08:11:00Z)
