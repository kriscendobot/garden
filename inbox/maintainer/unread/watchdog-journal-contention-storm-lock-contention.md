from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-03T01:19:15Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 37
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-03T01:19:15Z
---
WATCHDOG notice — occurrence #37 (first seen 2026-11-01T04:46:54Z, latest 2026-11-03T01:19:15Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 37 times; this is ONE
coalesced notice that updates in place, not 37 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.167291s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/worktree-sweeper/journal: p95=0.157352s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/inbox-list/journal: p95=0.095680s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.079248s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.100562s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/fork-watch/journal: p95=0.073102s, giveups=2, steals=0 (max 3/window), wait floor=60s.
