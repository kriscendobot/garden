from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-03T00:33:49Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 35
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-03T00:33:49Z
---
WATCHDOG notice — occurrence #35 (first seen 2026-11-01T04:46:54Z, latest 2026-11-03T00:33:49Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 35 times; this is ONE
coalesced notice that updates in place, not 35 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.014633s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.013967s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.013637s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.013765s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/screening/journal: p95=0.013553s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.014846s, giveups=1, steals=0 (max 3/window), wait floor=60s.
