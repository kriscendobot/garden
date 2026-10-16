from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-16T00:31:05Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 13
first_seen: 2026-10-15T22:51:05Z
last_seen: 2026-10-16T00:31:05Z
---
WATCHDOG notice — occurrence #13 (first seen 2026-10-15T22:51:05Z, latest 2026-10-16T00:31:05Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 13 times; this is ONE
coalesced notice that updates in place, not 13 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.012756s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.011942s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.013162s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.012376s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadmail/journal: p95=0.012946s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.012404s, giveups=1, steals=0 (max 3/window), wait floor=60s.
