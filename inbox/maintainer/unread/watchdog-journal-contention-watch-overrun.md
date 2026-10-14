from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-14T16:43:33Z
watchdog_key: journal-contention-watch-overrun
notice_count: 3
first_seen: 2026-10-14T01:36:55Z
last_seen: 2026-10-14T16:43:33Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-14T01:36:55Z, latest 2026-10-14T16:43:33Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal contention checker on oros-studio-garden-ce242c49 made no progress inside its 210s budget on consecutive ticks: analyzed=0, deferred work=31 (previous 31; clones=29 [busy=0], remedies=2, cleanup=0, notices=0).
