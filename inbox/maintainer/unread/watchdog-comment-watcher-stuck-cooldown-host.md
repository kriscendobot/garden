from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T09:42:14Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 57
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T09:42:14Z
---
WATCHDOG notice — occurrence #57 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T09:42:14Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 57 times; this is ONE
coalesced notice that updates in place, not 57 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 13 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790588784 set-by=receipt:kriscendobot-ymax-e2e:journal prerequisite
journal-outage marker: 1790588540 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 2817s (since 2026-09-28T08:55:16Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1370s (since 2026-09-28T09:19:23Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3232s (since 2026-09-28T08:48:21Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3582s (since 2026-09-28T08:42:31Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 2814s (since 2026-09-28T08:55:19Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3228s (since 2026-09-28T08:48:25Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3239s (since 2026-09-28T08:48:14Z)
- kriscendobot/list: watcher ticking but cooldown for 2488s (since 2026-09-28T09:00:45Z)
- kriscendobot/endo: watcher ticking but cooldown for 1375s (since 2026-09-28T09:19:18Z)
- kriscendobot/garden: https://github.com/kriscendobot/garden/issues/114#issuecomment-5864051232 (age=15115s; heartbeat=cooldown)
watcher ticking but cooldown for 3167s (since 2026-09-28T08:49:26Z)
watcher ticking but cooldown for 1371s (since 2026-09-28T09:19:22Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3235s (since 2026-09-28T08:48:18Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1395s (since 2026-09-28T09:18:58Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1408s (since 2026-09-28T09:18:45Z)
