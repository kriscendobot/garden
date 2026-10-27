from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-27T06:30:36Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 179
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-27T06:30:36Z
---
WATCHDOG notice — occurrence #179 (first seen 2026-10-16T17:37:14Z, latest 2026-10-27T06:30:36Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 179 times; this is ONE
coalesced notice that updates in place, not 179 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.015105s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.020148s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/foreman/journal: p95=0.018019s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.016776s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.014318s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.015021s, giveups=1, steals=0 (max 3/window), wait floor=60s.
