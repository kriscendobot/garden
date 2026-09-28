from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T00:40:54Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 37
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T00:40:54Z
---
WATCHDOG notice — occurrence #37 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T00:40:54Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 37 times; this is ONE
coalesced notice that updates in place, not 37 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 9 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790556087 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 2878s (since 2026-09-27T23:52:56Z)
- kriscendobot/finbot: watcher ticking but cooldown for 9038s (since 2026-09-27T22:10:16Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 2402s (since 2026-09-28T00:00:52Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 2831s (since 2026-09-27T23:53:43Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 2837s (since 2026-09-27T23:53:37Z)
- kriscendobot/list: watcher ticking but cooldown for 2074s (since 2026-09-28T00:06:20Z)
- kriscendobot/endo: watcher ticking but cooldown for 8684s (since 2026-09-27T22:16:10Z)
- kriscendobot/garden: watcher ticking but cooldown for 4258s (since 2026-09-27T23:29:56Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2072s (since 2026-09-28T00:06:22Z)
