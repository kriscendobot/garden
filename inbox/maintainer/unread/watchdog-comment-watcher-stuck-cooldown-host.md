from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T16:54:43Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 77
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T16:54:43Z
---
WATCHDOG notice — occurrence #77 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T16:54:43Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 77 times; this is ONE
coalesced notice that updates in place, not 77 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793898068 set-by=receipt:kriscendobot-ocapn:PR source:primary-quota <- receipt:kriscendobot-minion.town:journal prerequisite
gh-api GraphQL-only marker: expiry=1793898068 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 3215s (since 2026-11-05T16:01:08Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 3216s (since 2026-11-05T16:01:07Z)
- kriscendobot/test262: watcher ticking but cooldown for 3171s (since 2026-11-05T16:01:52Z)
- kriscendobot/moddable: watcher ticking but cooldown for 3216s (since 2026-11-05T16:01:07Z)
- kriscendobot/finbot: watcher ticking but cooldown for 3216s (since 2026-11-05T16:01:07Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 3216s (since 2026-11-05T16:01:07Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 3214s (since 2026-11-05T16:01:09Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 3214s (since 2026-11-05T16:01:09Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 3185s (since 2026-11-05T16:01:38Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 3216s (since 2026-11-05T16:01:07Z)
- kriscendobot/list: watcher ticking but cooldown for 3213s (since 2026-11-05T16:01:10Z)
- kriscendobot/endo: watcher ticking but cooldown for 3214s (since 2026-11-05T16:01:09Z)
- kriscendobot/garden: watcher ticking but cooldown for 3213s (since 2026-11-05T16:01:10Z)
watcher ticking but cooldown for 3215s (since 2026-11-05T16:01:08Z); detail: rest latch set-by=receipt:kriscendobot-ocapn:PR source:primary-quota <- receipt:kriscendobot-minion.town:journal prerequisite expiry=1793898068
- kriscendobot/minion.town: watcher ticking but cooldown for 3182s (since 2026-11-05T16:01:41Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 3216s (since 2026-11-05T16:01:07Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 3214s (since 2026-11-05T16:01:09Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 3214s (since 2026-11-05T16:01:09Z)
