from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-21T16:10:50Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 94
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-21T16:10:50Z
---
WATCHDOG notice — occurrence #94 (first seen 2026-10-16T17:37:14Z, latest 2026-10-21T16:10:50Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 94 times; this is ONE
coalesced notice that updates in place, not 94 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/screening-control/journal: p95=3.516053s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.058679s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.056449s, giveups=4, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.056763s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.077949s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.046252s, giveups=3, steals=0 (max 3/window), wait floor=60s.
