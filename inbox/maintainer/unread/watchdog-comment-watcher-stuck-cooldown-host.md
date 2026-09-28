from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T10:32:27Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 59
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T10:32:27Z
---
WATCHDOG notice — occurrence #59 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T10:32:27Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 59 times; this is ONE
coalesced notice that updates in place, not 59 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 14 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790591784 set-by=receipt:kriscendobot-test262:journal prerequisite
journal-outage marker: 1790591600 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 2573s (since 2026-09-28T09:49:25Z)
- kriscendobot/test262: watcher ticking but cooldown for 2528s (since 2026-09-28T09:50:10Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2121s (since 2026-09-28T09:56:57Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2123s (since 2026-09-28T09:56:55Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 2209s (since 2026-09-28T09:55:29Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2049s (since 2026-09-28T09:58:09Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 6233s (since 2026-09-28T08:48:25Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 6244s (since 2026-09-28T08:48:14Z)
- kriscendobot/list: watcher ticking but cooldown for 1702s (since 2026-09-28T10:03:56Z)
- kriscendobot/endo: watcher ticking but cooldown for 2204s (since 2026-09-28T09:55:34Z)
- kriscendobot/garden: https://github.com/kriscendobot/garden/issues/114#issuecomment-5864051232 (age=18120s; heartbeat=cooldown)
watcher ticking but cooldown for 2121s (since 2026-09-28T09:56:57Z)
watcher ticking but cooldown for 1722s (since 2026-09-28T10:03:36Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 1361s (since 2026-09-28T10:09:37Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2043s (since 2026-09-28T09:58:15Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 2056s (since 2026-09-28T09:58:02Z)
