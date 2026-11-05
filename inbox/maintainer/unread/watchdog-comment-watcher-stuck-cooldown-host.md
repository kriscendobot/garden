from_host: endolin-garden-ece02cb4
from: watchdog:comment-latency-watch
sent_at: 2026-11-05T04:51:25Z
watchdog_key: comment-watcher-stuck-cooldown-host
notice_count: 14
first_seen: 2026-11-05T03:11:18Z
last_seen: 2026-11-05T04:51:25Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-11-05T03:11:18Z, latest 2026-11-05T04:51:25Z).
The SAME condition (`comment-watcher-stuck-cooldown-host`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Comment watchers on endolin-garden-ece02cb4 are ticking but have been held in a shared cooldown/outage latch longer than 1200s on 1 source(s); they post no acknowledgments while it holds.
gh-api cooldown marker: expiry=1793857863 set-by=receipt:kriscendobot-ymax-stdio-mcp:PR source:primary-quota <- comment:source-timeout-fanout
gh-api GraphQL-only marker: expiry=1793857863 set-by=mirror-closer:primary-quota
- endojs/endo-but-for-bots: watcher ticking but cooldown for 4003s (since 2026-11-05T03:44:41Z)
