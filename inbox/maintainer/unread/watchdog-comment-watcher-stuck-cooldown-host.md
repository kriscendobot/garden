from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-27T16:55:34Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 19
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-27T16:55:34Z
---
WATCHDOG notice — occurrence #19 (first seen 2026-09-26T16:16:46Z, latest 2026-09-27T16:55:34Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 19 times; this is ONE
coalesced notice that updates in place, not 19 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 7 source(s); they post no acknowledgments while it holds.
journal-outage marker: 1790528204 cursor-get 
- kriscendobot/ocapn: watcher ticking but cooldown for 4039s (since 2026-09-27T15:48:11Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1375s (since 2026-09-27T16:32:35Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2789s (since 2026-09-27T16:09:01Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 4028s (since 2026-09-27T15:48:22Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3610s (since 2026-09-27T15:55:20Z)
- kriscendobot/endo: watcher ticking but cooldown for 3615s (since 2026-09-27T15:55:15Z)
- kriscendobot/garden: watcher ticking but cooldown for 2784s (since 2026-09-27T16:09:06Z)
