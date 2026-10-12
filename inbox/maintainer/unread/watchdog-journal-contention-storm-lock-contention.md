from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-12T12:09:08Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 45
first_seen: 2026-10-10T07:21:03Z
last_seen: 2026-10-12T12:09:08Z
---
WATCHDOG notice — occurrence #45 (first seen 2026-10-10T07:21:03Z, latest 2026-10-12T12:09:08Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 45 times; this is ONE
coalesced notice that updates in place, not 45 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 8 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 8 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.236858s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.138808s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.178394s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.204085s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.228390s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.178464s, giveups=2, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=0.225014s, giveups=2, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=116.548053s, giveups=23, steals=6 (max 3/window), wait floor=60s.
