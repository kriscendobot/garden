from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-26T17:10:43Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 12
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-26T17:10:43Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-09-26T16:16:46Z, latest 2026-09-26T17:10:43Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
- kriscendobot/test262: watcher ticking but offline-journal for 4590s (since 2026-09-26T15:53:56Z)
- kriscendobot/moddable: watcher ticking but offline-journal for 4754s (since 2026-09-26T15:51:12Z)
- kriscendobot/finbot: watcher ticking but offline-journal for 4650s (since 2026-09-26T15:52:56Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but offline-journal for 4574s (since 2026-09-26T15:54:12Z)
- kriscendobot/ymax-e2e: watcher ticking but offline-journal for 4601s (since 2026-09-26T15:53:45Z)
- endojs/endo-but-for-bots: watcher ticking but offline-journal for 4670s (since 2026-09-26T15:52:36Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but offline-journal for 4602s (since 2026-09-26T15:53:44Z)
- kriscendobot/list: watcher ticking but offline-journal for 4599s (since 2026-09-26T15:53:47Z)
- kriscendobot/garden: watcher ticking but offline-journal for 4575s (since 2026-09-26T15:54:11Z)
- kriscendobot/endo-but-for-bots: watcher ticking but offline-journal for 4935s (since 2026-09-26T15:48:11Z)
