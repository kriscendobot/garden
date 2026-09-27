from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T21:55:37Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 31
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T21:55:37Z
---
WATCHDOG notice — occurrence #31 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T21:55:37Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 31 times; this is ONE
coalesced notice that updates in place, not 31 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790546410 set-by=receipt:kriscendobot-oros-ckm-data-readiness:journal prerequisite
journal-outage marker: 1790546172 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 2230s (since 2026-09-27T21:18:27Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2203s (since 2026-09-27T21:18:54Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2231s (since 2026-09-27T21:18:26Z)
