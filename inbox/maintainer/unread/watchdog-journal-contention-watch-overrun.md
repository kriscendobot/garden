from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-12T18:32:13Z
watchdog_key: journal-contention-watch-overrun
notice_count: 2
first_seen: 2026-10-11T09:00:15Z
last_seen: 2026-10-12T18:32:13Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-11T09:00:15Z, latest 2026-10-12T18:32:13Z).
The SAME condition (`journal-contention-watch-overrun`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Journal contention checker on oros-studio-garden-ce242c49 made no progress inside its 210s budget on consecutive ticks: analyzed=0, deferred work=15 (previous 15; clones=15 [busy=0], remedies=0, cleanup=0, notices=0).
