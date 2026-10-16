from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-16T02:57:58Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 18
first_seen: 2026-10-15T22:51:05Z
last_seen: 2026-10-16T02:57:58Z
---
WATCHDOG notice — occurrence #18 (first seen 2026-10-15T22:51:05Z, latest 2026-10-16T02:57:58Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 18 times; this is ONE
coalesced notice that updates in place, not 18 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.057056s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gauntlet/journal: p95=53.950282s, giveups=0, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.061488s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.079479s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=0.050127s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.071990s, giveups=2, steals=0 (max 3/window), wait floor=60s.
