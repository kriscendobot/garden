from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-11T13:42:04Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 32
first_seen: 2026-10-10T07:21:03Z
last_seen: 2026-10-11T13:42:04Z
---
WATCHDOG notice — occurrence #32 (first seen 2026-10-10T07:21:03Z, latest 2026-10-11T13:42:04Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 32 times; this is ONE
coalesced notice that updates in place, not 32 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 8 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 8 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.163381s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.225581s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.158621s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gauntlet/journal: p95=0.199934s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.146975s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.219448s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=2.476473s, giveups=2, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.246407s, giveups=2, steals=0 (max 3/window), wait floor=60s.
