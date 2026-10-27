from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-27T11:45:43Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 182
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-27T11:45:43Z
---
WATCHDOG notice — occurrence #182 (first seen 2026-10-16T17:37:14Z, latest 2026-10-27T11:45:43Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 182 times; this is ONE
coalesced notice that updates in place, not 182 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.043322s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.037425s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.049601s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.037103s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/scheduler/journal: p95=0.047307s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.053794s, giveups=2, steals=0 (max 3/window), wait floor=60s.
