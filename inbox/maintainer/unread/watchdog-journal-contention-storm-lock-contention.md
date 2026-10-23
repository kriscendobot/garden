from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-23T17:45:59Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 121
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-23T17:45:59Z
---
WATCHDOG notice — occurrence #121 (first seen 2026-10-16T17:37:14Z, latest 2026-10-23T17:45:59Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 121 times; this is ONE
coalesced notice that updates in place, not 121 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/triager-pace/journal: p95=0.039491s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=0.141347s, giveups=9, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.030650s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.024658s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadmail/journal: p95=0.026675s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.028511s, giveups=1, steals=0 (max 3/window), wait floor=60s.
