from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-10-24T02:04:41Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 128
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-24T02:04:41Z
---
WATCHDOG notice — occurrence #128 (first seen 2026-10-16T17:37:14Z, latest 2026-10-24T02:04:41Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 128 times; this is ONE
coalesced notice that updates in place, not 128 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=0.277264s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.033336s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gauntlet/journal: p95=0.048059s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/gardener-scaler/journal: p95=0.034639s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/review-docket/journal: p95=0.028449s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.038708s, giveups=1, steals=0 (max 3/window), wait floor=60s.
