from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-16T12:01:50Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 10
first_seen: 2026-10-16T06:01:40Z
last_seen: 2026-10-16T12:01:50Z
---
WATCHDOG notice — occurrence #10 (first seen 2026-10-16T06:01:40Z, latest 2026-10-16T12:01:50Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 10 times; this is ONE
coalesced notice that updates in place, not 10 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.012905s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.012694s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=0.012821s, giveups=7, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.013070s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.014512s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.012844s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.014110s, giveups=1, steals=0 (max 3/window), wait floor=60s.
