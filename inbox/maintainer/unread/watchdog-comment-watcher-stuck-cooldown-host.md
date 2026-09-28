from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T07:31:23Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 51
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T07:31:23Z
---
WATCHDOG notice — occurrence #51 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T07:31:23Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 51 times; this is ONE
coalesced notice that updates in place, not 51 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 3 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790580967 set-by=receipt:kriscendobot-endo:journal prerequisite
journal-outage marker: 1790580754 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 2527s (since 2026-09-28T06:49:16Z)
- kriscendobot/endo: watcher ticking but cooldown for 8472s (since 2026-09-28T05:10:11Z)
- kriscendobot/garden: https://github.com/kriscendobot/garden/issues/114#issuecomment-5864051232 (age=7280s; heartbeat=cooldown)
watcher ticking but cooldown for 2503s (since 2026-09-28T06:49:40Z)
