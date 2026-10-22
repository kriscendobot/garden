from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-22T05:19:15Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 111
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-22T05:19:15Z
---
WATCHDOG notice — occurrence #111 (first seen 2026-10-16T17:37:14Z, latest 2026-10-22T05:19:15Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 111 times; this is ONE
coalesced notice that updates in place, not 111 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.013201s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/unblock/journal: p95=0.012415s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=0.070741s, giveups=4, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/design-pr-gauntlet-audit/journal: p95=0.012895s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.012668s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.012731s, giveups=1, steals=0 (max 3/window), wait floor=60s.
