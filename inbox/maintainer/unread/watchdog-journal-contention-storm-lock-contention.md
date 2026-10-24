from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-24T20:22:29Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 144
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-24T20:22:29Z
---
WATCHDOG notice — occurrence #144 (first seen 2026-10-16T17:37:14Z, latest 2026-10-24T20:22:29Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 144 times; this is ONE
coalesced notice that updates in place, not 144 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.035131s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=0.015367s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/fork-watch/journal: p95=0.013283s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.040382s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.032540s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.014367s, giveups=3, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.083121s, giveups=2, steals=0 (max 3/window), wait floor=60s.
