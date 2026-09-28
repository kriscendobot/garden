from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T04:31:26Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 45
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T04:31:26Z
---
WATCHDOG notice — occurrence #45 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T04:31:26Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 45 times; this is ONE
coalesced notice that updates in place, not 45 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 13 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790570123 set-by=receipt:kriscendobot-endo:journal prerequisite
journal-outage marker: 1790570004 approval-reconciler-verify 
- kriscendobot/cosgov: watcher ticking but cooldown for 2831s (since 2026-09-28T03:43:51Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1737s (since 2026-09-28T04:02:05Z)
- kriscendobot/test262: watcher ticking but cooldown for 2797s (since 2026-09-28T03:44:25Z)
- kriscendobot/moddable: watcher ticking but cooldown for 5008s (since 2026-09-28T03:07:34Z)
- kriscendobot/finbot: watcher ticking but cooldown for 4722s (since 2026-09-28T03:12:20Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2142s (since 2026-09-28T03:55:20Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3565s (since 2026-09-28T03:31:37Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 5124s (since 2026-09-28T03:05:38Z)
- kriscendobot/list: watcher ticking but cooldown for 1750s (since 2026-09-28T04:01:52Z)
- kriscendobot/garden: watcher ticking but cooldown for 1739s (since 2026-09-28T04:02:03Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1760s (since 2026-09-28T04:01:42Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 4256s (since 2026-09-28T03:20:06Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2129s (since 2026-09-28T03:55:33Z)
