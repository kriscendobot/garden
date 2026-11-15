from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-15T19:33:48Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 11
first_seen: 2026-11-13T06:01:28Z
last_seen: 2026-11-15T19:33:48Z
---
WATCHDOG notice — occurrence #11 (first seen 2026-11-13T06:01:28Z, latest 2026-11-15T19:33:48Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 11 times; this is ONE
coalesced notice that updates in place, not 11 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 17 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1794772845 set-by=receipt:kriscendobot-vattr97:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1794772844 set-by=mirror-closer:primary-quota
- kriscendobot/cosgov: watcher ticking but cooldown for 1982s (since 2026-11-15T19:00:45Z)
- kriscendobot/ocapn: watcher ticking but cooldown for 1981s (since 2026-11-15T19:00:46Z)
- kriscendobot/test262: watcher ticking but cooldown for 1981s (since 2026-11-15T19:00:46Z)
- kriscendobot/moddable: watcher ticking but cooldown for 1971s (since 2026-11-15T19:00:56Z)
- kriscendobot/finbot: watcher ticking but cooldown for 1937s (since 2026-11-15T19:01:30Z)
- kriscendobot/oros-ckm-data-readiness: watcher ticking but cooldown for 1981s (since 2026-11-15T19:00:46Z)
- kriscendobot/ymax-e2e: watcher ticking but cooldown for 1948s (since 2026-11-15T19:01:19Z)
- endojs/endo-but-for-bots: watcher ticking but cooldown for 1968s (since 2026-11-15T19:00:59Z)
- kriscendobot/ymax-stdio-mcp: watcher ticking but cooldown for 1979s (since 2026-11-15T19:00:48Z)
- kriscendobot/proposal-compartments: watcher ticking but cooldown for 1941s (since 2026-11-15T19:01:26Z)
- kriscendobot/list: watcher ticking but cooldown for 1982s (since 2026-11-15T19:00:45Z)
- kriscendobot/endo: watcher ticking but cooldown for 1981s (since 2026-11-15T19:00:46Z)
- kriscendobot/garden: watcher ticking but cooldown for 1981s (since 2026-11-15T19:00:46Z)
watcher ticking but cooldown for 1982s (since 2026-11-15T19:00:45Z); detail: rest latch set-by=receipt:kriscendobot-vattr97:PR source:primary-quota <- comment:source-timeout-fanout expiry=1794772845
- kriscendobot/minion.town: watcher ticking but cooldown for 1981s (since 2026-11-15T19:00:46Z)
- kriscendobot/vattr97: watcher ticking but cooldown for 1907s (since 2026-11-15T19:02:00Z)
- kriscendobot/endo-but-for-bots: watcher ticking but cooldown for 1951s (since 2026-11-15T19:01:16Z)
- kriscendobot/garden-book: watcher ticking but cooldown for 1983s (since 2026-11-15T19:00:44Z)
