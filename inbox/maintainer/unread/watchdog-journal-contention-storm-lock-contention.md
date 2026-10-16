from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-16T20:07:14Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 12
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-16T20:07:14Z
---
WATCHDOG notice — occurrence #12 (first seen 2026-10-16T17:37:14Z, latest 2026-10-16T20:07:14Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 12 times; this is ONE
coalesced notice that updates in place, not 12 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.012600s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=0.205711s, giveups=8, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/design-pr-gauntlet-audit/journal: p95=0.014329s, giveups=2, steals=1 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.014065s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/review-docket/journal: p95=0.012513s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reaper/journal: p95=0.013812s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.013819s, giveups=2, steals=0 (max 3/window), wait floor=60s.
