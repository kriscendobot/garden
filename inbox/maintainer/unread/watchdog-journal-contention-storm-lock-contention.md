from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-18T03:39:14Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 66
first_seen: 2026-11-13T05:48:51Z
last_seen: 2026-11-18T03:39:14Z
---
WATCHDOG notice — occurrence #66 (first seen 2026-11-13T05:48:51Z, latest 2026-11-18T03:39:14Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 66 times; this is ONE
coalesced notice that updates in place, not 66 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.017473s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.022125s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.017936s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.016824s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.015218s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.022272s, giveups=1, steals=0 (max 3/window), wait floor=60s.
