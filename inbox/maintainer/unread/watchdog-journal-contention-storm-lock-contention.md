from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-15T14:31:38Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 20
first_seen: 2026-10-14T08:23:55Z
last_seen: 2026-10-15T14:31:38Z
---
WATCHDOG notice — occurrence #20 (first seen 2026-10-14T08:23:55Z, latest 2026-10-15T14:31:38Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 20 times; this is ONE
coalesced notice that updates in place, not 20 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.050964s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.054709s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.119843s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.065422s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=24.203941s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.089495s, giveups=1, steals=0 (max 3/window), wait floor=60s.
