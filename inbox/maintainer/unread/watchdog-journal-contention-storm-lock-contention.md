from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-20T16:44:30Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 60
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-20T16:44:30Z
---
WATCHDOG notice — occurrence #60 (first seen 2026-10-16T17:37:14Z, latest 2026-10-20T16:44:30Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 60 times; this is ONE
coalesced notice that updates in place, not 60 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.256174s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/screening-control/journal: p95=119.812780s, giveups=0, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.081430s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.066171s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.103598s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=30.326583s, giveups=1, steals=0 (max 3/window), wait floor=60s.
