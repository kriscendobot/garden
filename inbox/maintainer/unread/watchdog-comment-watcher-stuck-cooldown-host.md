from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T14:06:59Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 67
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T14:06:59Z
---
WATCHDOG notice — occurrence #67 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T14:06:59Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 67 times; this is ONE
coalesced notice that updates in place, not 67 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 5 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790604690 set-by=receipt:kriscendobot-endo:journal prerequisite
journal-outage marker: 1790604501 approval-reconciler-verify 
- kriscendobot/cosgov: watcher ticking but cooldown for 4691s (since 2026-09-28T12:48:48Z)
- kriscendobot/test262: watcher ticking but cooldown for 5133s (since 2026-09-28T12:41:26Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1706s (since 2026-09-28T13:38:33Z)
- kriscendobot/list: watcher ticking but cooldown for 2150s (since 2026-09-28T13:31:09Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 5126s (since 2026-09-28T12:41:33Z)
