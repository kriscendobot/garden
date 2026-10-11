from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-10-11T20:06:54Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 4
first_seen: 2026-10-09T18:02:55Z
last_seen: 2026-10-11T20:06:54Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-09T18:02:55Z, latest 2026-10-11T20:06:54Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 14 source(s); they post no acknowledgments while it holds.
- kriscendobot/cosgov: watcher ticking but cooldown for 3586s (since 2026-10-11T19:07:07Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3599s (since 2026-10-11T19:06:54Z)
- kriscendobot/test262: watcher ticking but cooldown for 3585s (since 2026-10-11T19:07:08Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3580s (since 2026-10-11T19:07:13Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3607s (since 2026-10-11T19:06:46Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3558s (since 2026-10-11T19:07:35Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3647s (since 2026-10-11T19:06:06Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3610s (since 2026-10-11T19:06:43Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3643s (since 2026-10-11T19:06:10Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3637s (since 2026-10-11T19:06:16Z)
- kriscendobot/garden: watcher ticking but cooldown for 3632s (since 2026-10-11T19:06:21Z)
watcher ticking but cooldown for 3570s (since 2026-10-11T19:07:23Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 3611s (since 2026-10-11T19:06:42Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3593s (since 2026-10-11T19:07:00Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3648s (since 2026-10-11T19:06:05Z)
