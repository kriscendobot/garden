from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-03T11:18:46Z
watchdog_key: journal-contention-watch-overrun
notice_count: 15
first_seen: 2026-10-03T05:02:31Z
last_seen: 2026-10-03T11:18:46Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-10-03T05:02:31Z, latest 2026-10-03T11:18:46Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

Journal contention checker on endolin-garden-ece02cb4 cannot finish a tick inside its 210s budget: deferred 1144 of 1163 clone(s) on consecutive ticks.
