from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T03:40:56Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 43
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T03:40:56Z
---
WATCHDOG notice — occurrence #43 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T03:40:56Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 43 times; this is ONE
coalesced notice that updates in place, not 43 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 9 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790566891 cursor-get 
- kriscendobot/test262: watcher ticking but cooldown for 3235s (since 2026-09-28T02:47:00Z)
- kriscendobot/moddable: watcher ticking but cooldown for 2001s (since 2026-09-28T03:07:34Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1715s (since 2026-09-28T03:12:20Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1662s (since 2026-09-28T03:13:13Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2071s (since 2026-09-28T03:06:24Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2117s (since 2026-09-28T03:05:38Z)
- kriscendobot/endo: watcher ticking but cooldown for 3547s (since 2026-09-28T02:41:48Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1249s (since 2026-09-28T03:20:06Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1663s (since 2026-09-28T03:13:12Z)
