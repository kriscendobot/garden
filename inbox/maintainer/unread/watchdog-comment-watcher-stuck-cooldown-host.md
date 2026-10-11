from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-10-11T11:56:45Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 3
first_seen: 2026-10-09T18:02:55Z
last_seen: 2026-10-11T11:56:45Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-09T18:02:55Z, latest 2026-10-11T11:56:45Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 2 source(s); they post no acknowledgments while it holds.
- kriscendobot/ocapn: watcher ticking but cooldown for 3696s (since 2026-10-11T10:55:08Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3670s (since 2026-10-11T10:55:34Z)
