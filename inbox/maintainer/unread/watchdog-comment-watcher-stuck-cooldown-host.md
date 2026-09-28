from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T12:22:08Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 63
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T12:22:08Z
---
WATCHDOG notice — occurrence #63 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T12:22:08Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 63 times; this is ONE
coalesced notice that updates in place, not 63 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 6 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790598407 set-by=receipt:kriscendobot-list:journal prerequisite
journal-outage marker: 1790598188 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 2889s (since 2026-09-28T11:33:51Z)
- kriscendobot/test262: watcher ticking but cooldown for 9110s (since 2026-09-28T09:50:10Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1751s (since 2026-09-28T11:52:49Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3897s (since 2026-09-28T11:17:03Z)
- kriscendobot/list: watcher ticking but cooldown for 8284s (since 2026-09-28T10:03:56Z)
- kriscendobot/garden: watcher ticking but cooldown for 3959s (since 2026-09-28T11:16:01Z)
