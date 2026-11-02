from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-02T11:33:13Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 17
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-02T11:33:13Z
---
WATCHDOG notice — occurrence #17 (first seen 2026-11-01T04:46:54Z, latest 2026-11-02T11:33:13Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 17 times; this is ONE
coalesced notice that updates in place, not 17 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.026392s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.021330s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.031147s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.023786s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.019009s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.054404s, giveups=2, steals=0 (max 3/window), wait floor=60s.
