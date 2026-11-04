from_host: oros-studio-garden-ce242c49
from: watchdog:journal-contention-watch
sent_at: 2026-11-04T06:55:58Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 59
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-04T06:55:58Z
---
WATCHDOG notice — occurrence #59 (first seen 2026-11-01T04:46:54Z, latest 2026-11-04T06:55:58Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 59 times; this is ONE
coalesced notice that updates in place, not 59 messages. Latest detail:

Journal contention storm on oros-studio-garden-ce242c49: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/regenerate-sections-index/journal: p95=2.399763s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/repo-watcher/journal: p95=0.079057s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/review-docket/journal: p95=87.634481s, giveups=0, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/unblock/journal: p95=0.238801s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/self-deploy/journal: p95=0.572659s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on oros-studio-garden-ce242c49 for /Users/dom/garden/.garden-state/decisions/journal: p95=0.319656s, giveups=1, steals=0 (max 3/window), wait floor=60s.
