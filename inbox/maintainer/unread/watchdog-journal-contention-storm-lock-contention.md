from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-16T20:33:36Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 14
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-16T20:33:36Z
---
WATCHDOG notice — occurrence #14 (first seen 2026-10-16T17:37:14Z, latest 2026-10-16T20:33:36Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 14 times; this is ONE
coalesced notice that updates in place, not 14 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.221496s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.068062s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.061402s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.140057s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.052938s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.037142s, giveups=3, steals=0 (max 3/window), wait floor=60s.
