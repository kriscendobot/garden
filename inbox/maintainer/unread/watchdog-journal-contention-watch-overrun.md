from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T19:40:37Z
watchdog_key: journal-contention-watch-overrun
notice_count: 4
first_seen: 2026-10-02T17:51:26Z
last_seen: 2026-10-02T19:40:37Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-02T17:51:26Z, latest 2026-10-02T19:40:37Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1031 of 1031 clone(s) on consecutive ticks.
