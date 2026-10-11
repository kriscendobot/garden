from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-11T11:27:17Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 27
first_seen: 2026-10-10T07:21:03Z
last_seen: 2026-10-11T11:27:17Z
---
WATCHDOG notice — occurrence #27 (first seen 2026-10-10T07:21:03Z, latest 2026-10-11T11:27:17Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 27 times; this is ONE
coalesced notice that updates in place, not 27 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.181747s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.163348s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gauntlet/journal: p95=0.199934s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.161753s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.091174s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=15.423175s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.316237s, giveups=1, steals=0 (max 3/window), wait floor=60s.
