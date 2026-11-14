from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-14T05:49:41Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 12
first_seen: 2026-11-13T05:48:51Z
last_seen: 2026-11-14T05:49:41Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-11-13T05:48:51Z, latest 2026-11-14T05:49:41Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/regenerate-sections-index/journal: p95=0.030763s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.027745s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.042453s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/scheduler/journal: p95=0.027257s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.037361s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.032880s, giveups=2, steals=0 (max 3/window), wait floor=60s.
