from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T17:20:22Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 20
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T17:20:22Z
---
WATCHDOG notice — occurrence #20 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T17:20:22Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 20 times; this is ONE
coalesced notice that updates in place, not 20 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 8 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790529897 set-by=receipt:kriscendobot-garden:journal prerequisite
journal-outage marker: 1790529721 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 5524s (since 2026-09-27T15:48:11Z)
- kriscendobot/test262: watcher ticking but cooldown for 1345s (since 2026-09-27T16:57:50Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2860s (since 2026-09-27T16:32:35Z)
- kriscendobot/finbot: watcher ticking but cooldown for 4274s (since 2026-09-27T16:09:01Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2481s (since 2026-09-27T16:38:54Z)
- kriscendobot/list: watcher ticking but cooldown for 2042s (since 2026-09-27T16:46:13Z)
- kriscendobot/endo: watcher ticking but cooldown for 5100s (since 2026-09-27T15:55:15Z)
- kriscendobot/garden: watcher ticking but cooldown for 4269s (since 2026-09-27T16:09:06Z)
