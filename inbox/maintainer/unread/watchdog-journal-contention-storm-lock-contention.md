from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T08:51:29Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 67
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-04T08:51:29Z
---
WATCHDOG notice — occurrence #67 (first seen 2026-11-01T04:46:54Z, latest 2026-11-04T08:51:29Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 67 times; this is ONE
coalesced notice that updates in place, not 67 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.552961s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.177532s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/review-docket/journal: p95=0.213803s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=0.305135s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=41.468674s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/decisions/journal: p95=0.319656s, giveups=1, steals=0 (max 3/window), wait floor=60s.
