from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-21T01:17:51Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 74
first_seen: 2026-10-16T17:37:14Z
last_seen: 2026-10-21T01:17:51Z
---
WATCHDOG notice — occurrence #74 (first seen 2026-10-16T17:37:14Z, latest 2026-10-21T01:17:51Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 74 times; this is ONE
coalesced notice that updates in place, not 74 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 7 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 7 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/comment-latency-watch/journal: p95=0.043131s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.043539s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/producer/journal: p95=0.014660s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/deadline-nudge/journal: p95=0.017688s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.047561s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/bulletin/journal: p95=0.014047s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.040807s, giveups=1, steals=0 (max 3/window), wait floor=60s.
