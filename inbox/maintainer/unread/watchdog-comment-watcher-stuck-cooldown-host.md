from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T05:16:17Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 47
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T05:16:17Z
---
WATCHDOG notice — occurrence #47 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T05:16:17Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 47 times; this is ONE
coalesced notice that updates in place, not 47 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790572818 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
- kriscendobot/test262: watcher ticking but cooldown for 1430s (since 2026-09-28T04:52:19Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 4849s (since 2026-09-28T03:55:20Z)
- kriscendobot/garden: watcher ticking but cooldown for 1891s (since 2026-09-28T04:44:38Z)
