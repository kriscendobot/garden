from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-11-05T10:35:58Z
watchdog_key: journal-contention-storm-lock-contention
notice_count: 101
first_seen: 2026-11-01T04:46:54Z
last_seen: 2026-11-05T10:35:58Z
---
WATCHDOG notice — occurrence #101 (first seen 2026-11-01T04:46:54Z, latest 2026-11-05T10:35:58Z).
The SAME condition (`journal-contention-storm-lock-contention`) has now been observed 101 times; this is ONE
coalesced notice that updates in place, not 101 messages. Latest detail:

Journal contention storm on endolin-garden-ece02cb4: 6 clones hit lock-contention in one tick (storm guard > 5; one shared cause is likelier than 6 independent faults):
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/proxy/journal: p95=0.056166s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/sysop/journal: p95=0.065074s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/follow-up/journal: p95=0.058343s, giveups=2, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/reducer/journal: p95=0.065043s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/requirements-watch/journal: p95=0.063435s, giveups=1, steals=0 (max 3/window), wait floor=60s.
- Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/worktree-sweeper/journal: p95=0.082393s, giveups=1, steals=0 (max 3/window), wait floor=60s.
