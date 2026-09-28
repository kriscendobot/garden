from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-09-28T13:41:51Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 66
first_seen: 2026-09-26T16:16:46Z
last_seen: 2026-09-28T13:41:51Z
---
WATCHDOG notice — occurrence #66 (first seen 2026-09-26T16:16:46Z, latest 2026-09-28T13:41:51Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 66 times; this is ONE
coalesced notice that updates in place, not 66 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 10 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1790603192 set-by=receipt:kriscendobot-moddable:journal prerequisite
journal-outage marker: 1790602885 cursor-get 
- kriscendobot/cosgov: watcher ticking but cooldown for 3183s (since 2026-09-28T12:48:48Z)
- kriscendobot/test262: watcher ticking but cooldown for 3625s (since 2026-09-28T12:41:26Z)
- kriscendobot/finbot: watcher ticking but cooldown for 2448s (since 2026-09-28T13:01:03Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1679s (since 2026-09-28T13:13:52Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3619s (since 2026-09-28T12:41:32Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 5469s (since 2026-09-28T12:10:42Z)
- kriscendobot/garden: watcher ticking but cooldown for 2396s (since 2026-09-28T13:01:55Z)
- kriscendobot/minion.town: watcher ticking but cooldown for 2395s (since 2026-09-28T13:01:56Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 2397s (since 2026-09-28T13:01:54Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3618s (since 2026-09-28T12:41:33Z)
