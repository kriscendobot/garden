from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T00:50:31Z
watchdog_key: journal-contention-watch-overrun
notice_count: 4
first_seen: 2026-10-14T01:36:55Z
last_seen: 2026-10-15T00:50:31Z
---
WATCHDOG notice — occurrence #4 (first seen 2026-10-14T01:36:55Z, latest 2026-10-15T00:50:31Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 4 times; this is ONE
coalesced notice that updates in place, not 4 messages. Latest detail:

Journal contention checker on oros-studio-garden-ce242c49 made no progress inside its 210s budget on consecutive ticks: analyzed=0, deferred work=326 (previous 326; clones=325 [busy=0], remedies=0, cleanup=0, notices=1).
