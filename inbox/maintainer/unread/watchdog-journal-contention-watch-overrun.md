from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-14T09:35:56Z
watchdog_key: journal-contention-watch-overrun
notice_count: 2
first_seen: 2026-10-14T01:36:55Z
last_seen: 2026-10-14T09:35:56Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-14T01:36:55Z, latest 2026-10-14T09:35:56Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention checker on oros-studio-garden-ce242c49 made no progress inside its 210s budget on consecutive ticks: analyzed=0, deferred work=184 (previous 184; clones=184 [busy=0], remedies=0, cleanup=0, notices=0).
