from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T11:27:14Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 61
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T11:27:14Z
---
WATCHDOG notice — occurrence #61 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T11:27:14Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 61 times; this is ONE
coalesced notice that updates in place, not 61 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 4 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790595109 set-by=receipt:kriscendobot-minion.town:journal prerequisite
journal-outage marker: 1790594926 approval-reconciler-verify 
- kriscendobot/cosgov: watcher ticking but cooldown for 4284s (since 2026-09-28T10:15:43Z)
- kriscendobot/test262: watcher ticking but cooldown for 5817s (since 2026-09-28T09:50:10Z)
- kriscendobot/list: watcher ticking but cooldown for 4991s (since 2026-09-28T10:03:56Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 5332s (since 2026-09-28T09:58:15Z)
