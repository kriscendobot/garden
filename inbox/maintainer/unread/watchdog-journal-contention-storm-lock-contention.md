from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-11T13:49:57Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 33
first_seen: 2026-10-10T07:21:03Z
last_seen: 2026-10-11T13:49:57Z
---
WATCHDOG notice — occurrence #33 (first seen 2026-10-10T07:21:03Z, latest 2026-10-11T13:49:57Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 33 times; this is ONE
coalesced notice that updates in place, not 33 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 9 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 9 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.163381s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.225581s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.157416s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gauntlet/journal: p95=0.199934s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.144053s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.219448s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.120318s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=1.760435s, giveups=2, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.246456s, giveups=2, steals=0 (max 3/window), wait floor=60s.
