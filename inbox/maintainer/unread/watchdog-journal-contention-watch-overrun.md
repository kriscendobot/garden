from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-02T15:54:38Z
watchdog_key: journal-contention-watch-overrun
notice_count: 34
first_seen: 2026-10-01T20:53:24Z
last_seen: 2026-10-02T15:54:38Z
---
WATCHDOG notice — occurrence #34 (first seen 2026-10-01T20:53:24Z, latest 2026-10-02T15:54:38Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 34 times; this is ONE
coalesced notice that updates in place, not 34 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 928 of 1001 clone(s) on consecutive ticks.
