from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T11:02:11Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 75
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-04T11:02:11Z
---
WATCHDOG notice — occurrence #75 (first seen 2026-11-01T04:46:54Z, latest 2026-11-04T11:02:11Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 75 times; this is ONE
coalesced notice that updates in place, not 75 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.552961s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.586087s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/review-docket/journal: p95=0.213803s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.290167s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/sysop/journal: p95=0.310511s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=41.068076s, giveups=4, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/decisions/journal: p95=0.319656s, giveups=1, steals=0 (max 3/window), wait floor=60s.
