from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T07:06:47Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 61
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-04T07:06:47Z
---
WATCHDOG notice — occurrence #61 (first seen 2026-11-01T04:46:54Z, latest 2026-11-04T07:06:47Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 61 times; this is ONE
coalesced notice that updates in place, not 61 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 9 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 9 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=2.399763s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.177532s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.073977s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/review-docket/journal: p95=87.634481s, giveups=0, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.228596s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=0.572659s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/producer/journal: p95=41.816439s, giveups=2, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.100343s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/decisions/journal: p95=0.319656s, giveups=1, steals=0 (max 3/window), wait floor=60s.
