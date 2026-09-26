from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T17:01:09Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 10
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T17:01:09Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T17:01:09Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 14 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790442136 cursor-get 
- kriscendobot/cosgov: watcher ticking but offline-journal for 3979s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 4067s (since 2026-09-26T15:52:39Z)
- kriscendobot/test262: watcher ticking but offline-journal for 3990s (since 2026-09-26T15:53:56Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 4050s (since 2026-09-26T15:52:56Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 3974s (since 2026-09-26T15:54:12Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 4001s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 4070s (since 2026-09-26T15:52:36Z)
- kriscendobot/proposal-compartments: watcher ticking but offline-journal for 4037s (since 2026-09-26T15:53:09Z)
- kriscendobot/list: watcher ticking but offline-journal for 3999s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 4039s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 4053s (since 2026-09-26T15:52:53Z)
watcher ticking but offline-journal for 3975s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 4109s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 4043s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 4335s (since 2026-09-26T15:48:11Z)
