from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T16:46:06Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 7
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T16:46:06Z
---
WATCHDOG notice — occurrence #7 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T16:46:06Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 7 times; this is ONE
coalesced notice that updates in place, not 7 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 15 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790441235 cursor-get 
- kriscendobot/cosgov: watcher ticking but offline-journal for 3080s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 3168s (since 2026-09-26T15:52:39Z)
- kriscendobot/test262: watcher ticking but offline-journal for 3091s (since 2026-09-26T15:53:56Z)
- kriscendobot/moddable: watcher ticking but offline-journal for 3255s (since 2026-09-26T15:51:12Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 3151s (since 2026-09-26T15:52:56Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 3075s (since 2026-09-26T15:54:12Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 3171s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 3103s (since 2026-09-26T15:53:44Z)
- kriscendobot/proposal-compartments: watcher ticking but offline-journal for 3138s (since 2026-09-26T15:53:09Z)
- kriscendobot/list: watcher ticking but offline-journal for 3100s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 3140s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 3154s (since 2026-09-26T15:52:53Z)
watcher ticking but offline-journal for 3076s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 3210s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 3144s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 3436s (since 2026-09-26T15:48:11Z)
