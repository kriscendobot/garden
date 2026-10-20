from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-20T03:15:58Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 53
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-20T03:15:58Z
---
WATCHDOG notice — occurrence #53 (first seen 2026-10-16T17:37:14Z, latest 2026-10-20T03:15:58Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 53 times; this is ONE
coalesced notice that updates in place, not 53 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/orch/journal: p95=0.019608s, giveups=2, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=0.022070s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=1.503350s, giveups=7, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.024450s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.038115s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.027375s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.042734s, giveups=1, steals=0 (max 3/window), wait floor=60s.
