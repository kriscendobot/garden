from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T17:05:52Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 11
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T17:05:52Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T17:05:52Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 16 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790442451 cursor-get 
- kriscendobot/cosgov: watcher ticking but offline-journal for 4288s (since 2026-09-26T15:54:07Z)
- kriscendobot/ocapn: watcher ticking but offline-journal for 4376s (since 2026-09-26T15:52:39Z)
- kriscendobot/test262: watcher ticking but offline-journal for 4299s (since 2026-09-26T15:53:56Z)
- kriscendobot/moddable: watcher ticking but offline-journal for 4463s (since 2026-09-26T15:51:12Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 4359s (since 2026-09-26T15:52:56Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 4283s (since 2026-09-26T15:54:12Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 4310s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 4379s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 4311s (since 2026-09-26T15:53:44Z)
- kriscendobot/proposal-compartments: watcher ticking but offline-journal for 4346s (since 2026-09-26T15:53:09Z)
- kriscendobot/list: watcher ticking but offline-journal for 4308s (since 2026-09-26T15:53:47Z)
- kriscendobot/endo: watcher ticking but offline-journal for 4348s (since 2026-09-26T15:53:07Z)
- kriscendobot/garden: watcher ticking but offline-journal for 4362s (since 2026-09-26T15:52:53Z)
watcher ticking but offline-journal for 4284s (since 2026-09-26T15:54:11Z)
- kriscendobot/minion.town: watcher ticking but offline-journal for 4418s (since 2026-09-26T15:51:57Z)
- kriscendobot/vattr97: watcher ticking but offline-journal for 4352s (since 2026-09-26T15:53:03Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 4644s (since 2026-09-26T15:48:11Z)
