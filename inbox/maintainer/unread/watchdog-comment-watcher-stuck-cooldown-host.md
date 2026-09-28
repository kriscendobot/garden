from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T04:06:34Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 44
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T04:06:34Z
---
WATCHDOG notice — occurrence #44 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T04:06:34Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 44 times; this is ONE
coalesced notice that updates in place, not 44 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 9 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790568670 set-by=receipt:kriscendobot-ymax-stdio-mcp:journal prerequisite
- kriscendobot/cosgov: watcher ticking but cooldown for 1335s (since 2026-09-28T03:43:51Z)
- kriscendobot/test262: watcher ticking but cooldown for 1301s (since 2026-09-28T03:44:25Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3512s (since 2026-09-28T03:07:34Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3226s (since 2026-09-28T03:12:20Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3173s (since 2026-09-28T03:13:13Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3582s (since 2026-09-28T03:06:24Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3628s (since 2026-09-28T03:05:38Z)
- kriscendobot/endo: watcher ticking but cooldown for 5058s (since 2026-09-28T02:41:48Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2760s (since 2026-09-28T03:20:06Z)
