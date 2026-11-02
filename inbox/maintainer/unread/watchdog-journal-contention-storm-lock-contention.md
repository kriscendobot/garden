from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-02T09:38:09Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 15
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-02T09:38:09Z
---
WATCHDOG notice — occurrence #15 (first seen 2026-11-01T04:46:54Z, latest 2026-11-02T09:38:09Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 15 times; this is ONE
coalesced notice that updates in place, not 15 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/screening-control/journal: p95=119.610110s, giveups=0, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.106896s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.094055s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.094576s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.137820s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.052973s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.093417s, giveups=2, steals=0 (max 3/window), wait floor=60s.
