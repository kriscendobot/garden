from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T04:01:56Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 14
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T04:01:56Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T04:01:56Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 1 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790481945 set-by=receipt:kriscendobot-test262:journal prerequisite
journal-outage marker: 1790481779 ci-watcher-verify 
- kriscendobot/garden: watcher ticking but cooldown for 1369s (since 2026-09-27T03:39:07Z)
